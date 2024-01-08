const { ethers } = require("hardhat");
const { expect, getContract, deploy, bigIntEq } = require("./setup");

const { ZeroAddress } = ethers;

const TEST_TOKEN = getContract(
  require(`../build/TestToken.json`),
  "TestToken.sol",
  "TestToken"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-078.json`),
  "sol-078.sol",
  "CSAMM"
);

describe("CSAMM", () => {
  let csamm;
  let accounts = [];
  let users = [];
  let token0;
  let token1;

  before(async () => {
    accounts = await ethers.getSigners();
    users = [accounts[0], accounts[1], accounts[2]];

    const tokenA = await deploy(TEST_TOKEN, {
      account: accounts[0],
      args: ["token A", "TOKENA", 18],
    });
    const tokenB = await deploy(TEST_TOKEN, {
      account: accounts[0],
      args: ["token B", "TOKEN B", 18],
    });

    if (tokenA.target <= tokenB.target) {
      token0 = tokenA;
      token1 = tokenB;
    } else {
      token0 = tokenB;
      token1 = tokenA;
    }

    csamm = await deploy(json, {
      account: accounts[0],
      args: [token0.target, token1.target],
    });

    for (const user of users) {
      for (const token of [token0, token1]) {
        const amount = 1000n * 10n ** 18n;
        token.mint(user.address, amount);
        token.connect(user).approve(csamm.target, amount);
      }
    }
  });

  describe("addLiquidity", () => {
    it("addLiquidity - when total supply = 0", async () => {
      const user = users[0];
      const amount0 = 100n * 10n ** 18n;
      const amount1 = 200n * 10n ** 18n;

      await csamm.connect(user).addLiquidity(amount0, amount1);

      bigIntEq(await csamm.totalSupply(), amount0 + amount1, "total supply");
      bigIntEq(
        await csamm.balanceOf(user.address),
        amount0 + amount1,
        "balance of user"
      );
      bigIntEq(await csamm.reserve0(), amount0, "reserve0");
      bigIntEq(await csamm.reserve1(), amount1, "reserve1");
      bigIntEq(
        await token0.balanceOf(csamm.target),
        amount0,
        "token0 balance of CSAMM"
      );
      bigIntEq(
        await token1.balanceOf(csamm.target),
        amount1,
        "token1 balance of CSAMM"
      );
    });

    it("addLiquidity - when total supply > 0", async () => {
      const user = users[1];
      const amount0 = 50n * 10n ** 18n;
      const amount1 = 50n * 10n ** 18n;

      const [totalSupply, res0, res1, bal0, bal1] = await Promise.all([
        csamm.totalSupply(),
        csamm.reserve0(),
        csamm.reserve1(),
        token0.balanceOf(csamm.target),
        token1.balanceOf(csamm.target),
      ]);

      await csamm.connect(user).addLiquidity(amount0, amount1);

      bigIntEq(
        await csamm.totalSupply(),
        totalSupply + amount0 + amount1,
        "total supply"
      );
      bigIntEq(
        await csamm.balanceOf(user.address),
        amount0 + amount1,
        "balance of user"
      );
      bigIntEq(await csamm.reserve0(), res0 + amount0, "reserve0");
      bigIntEq(await csamm.reserve1(), res1 + amount1, "reserve1");
      bigIntEq(
        await token0.balanceOf(csamm.target),
        bal0 + amount0,
        "token0 balance of CSAMM"
      );
      bigIntEq(
        await token1.balanceOf(csamm.target),
        bal1 + amount1,
        "token1 balance of CSAMM"
      );
    });

    it("addLiquidity - fails if shares to mint = 0", async () => {
      await expect(csamm.addLiquidity(0, 0)).to.be.reverted;
    });
  });

  describe("swap", () => {
    it("swap -fails if token != token 0 and token 1", async () => {
      await expect(csamm.swap(ZeroAddress, 0)).to.be.reverted;
    });

    it("swap - token 0 to token 1", async () => {
      const user = users[2];
      const amount0In = 100n * 10n ** 18n;
      const amount1Out = (amount0In * 997n) / 1000n;

      const [res0, res1, bal0, bal1, userBal0, userBal1] = await Promise.all([
        csamm.reserve0(),
        csamm.reserve1(),
        token0.balanceOf(csamm.target),
        token1.balanceOf(csamm.target),
        token0.balanceOf(user.address),
        token1.balanceOf(user.address),
      ]);

      await csamm.connect(users[2]).swap(token0.target, amount0In);

      // csamm balances
      bigIntEq(
        await token0.balanceOf(csamm.target),
        bal0 + amount0In,
        "token0 balance of CSAMM"
      );
      bigIntEq(
        await token1.balanceOf(csamm.target),
        bal1 - amount1Out,
        "token1 balance of CSAMM"
      );
      // user balances
      bigIntEq(
        await token0.balanceOf(user.address),
        userBal0 - amount0In,
        "token0 balance of user"
      );
      bigIntEq(
        await token1.balanceOf(user.address),
        userBal1 + amount1Out,
        "token1 balance of user"
      );
      // reserves
      bigIntEq(await csamm.reserve0(), res0 + amount0In, "reserve0");
      bigIntEq(await csamm.reserve1(), res1 - amount1Out, "reserve1");
    });

    it("swap - token 1 to token 0", async () => {
      const user = users[2];
      const amount1In = 50n * 10n ** 18n;
      const amount0Out = (amount1In * 997n) / 1000n;

      const [res0, res1, bal0, bal1, userBal0, userBal1] = await Promise.all([
        csamm.reserve0(),
        csamm.reserve1(),
        token0.balanceOf(csamm.target),
        token1.balanceOf(csamm.target),
        token0.balanceOf(user.address),
        token1.balanceOf(user.address),
      ]);

      await csamm.connect(user).swap(token1.target, amount1In);

      // csamm balances
      bigIntEq(
        await token0.balanceOf(csamm.target),
        bal0 - amount0Out,
        "token0 balance of CSAMM"
      );
      bigIntEq(
        await token1.balanceOf(csamm.target),
        bal1 + amount1In,
        "token1 balance of CSAMM"
      );
      // user balances
      bigIntEq(
        await token0.balanceOf(user.address),
        userBal0 + amount0Out,
        "token0 balance of user"
      );
      bigIntEq(
        await token1.balanceOf(user.address),
        userBal1 - amount1In,
        "token1 balance of user"
      );
      // reserves
      bigIntEq(await csamm.reserve0(), res0 - amount0Out, "reserve0");
      bigIntEq(await csamm.reserve1(), res1 + amount1In, "reserve1");
    });
  });

  describe("removeLiquidity", () => {
    it("removeLiquidity", async () => {
      const user = users[0];

      const [totalSupply, shares, res0, res1, bal0, bal1, userBal0, userBal1] =
        await Promise.all([
          csamm.totalSupply(),
          csamm.balanceOf(user.address),
          csamm.reserve0(),
          csamm.reserve1(),
          token0.balanceOf(csamm.target),
          token1.balanceOf(csamm.target),
          token0.balanceOf(user.address),
          token1.balanceOf(user.address),
        ]);

      const amount0Out = (res0 * shares) / totalSupply;
      const amount1Out = (res1 * shares) / totalSupply;

      await csamm.connect(user).removeLiquidity(shares);

      // csamm balances
      bigIntEq(
        await token0.balanceOf(csamm.target),
        bal0 - amount0Out,
        "token0 balance of CSAMM"
      );
      bigIntEq(
        await token1.balanceOf(csamm.target),
        bal1 - amount1Out,
        "token1 balance of CSAMM"
      );
      // user balances
      bigIntEq(
        await token0.balanceOf(user.address),
        userBal0 + amount0Out,
        "token0 balance of user"
      );
      bigIntEq(
        await token1.balanceOf(user.address),
        userBal1 + amount1Out,
        "token1 balance of user"
      );
      // shares
      bigIntEq(await csamm.totalSupply(), totalSupply - shares, "total supply");
      bigIntEq(await csamm.balanceOf(user.address), 0, "balance of user");
      // reserves
      bigIntEq(await csamm.reserve0(), res0 - amount0Out, "reserve0");
      bigIntEq(await csamm.reserve1(), res1 - amount1Out, "reserve1");
    });
  });
});

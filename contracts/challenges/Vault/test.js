const { ethers } = require("hardhat");
const { getContract, deploy, bigIntEq } = require("./setup");

const TEST_TOKEN = getContract(
  require(`../build/TestToken.json`),
  "TestToken.sol",
  "TestToken"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-077.json`),
  "sol-077.sol",
  "Vault"
);

describe("Vault", () => {
  let vault;
  let accounts = [];
  let token;

  before(async () => {
    accounts = await ethers.getSigners();
    token = await deploy(TEST_TOKEN, {
      account: accounts[0],
      args: ["token", "TOKEN", 18],
    });
    vault = await deploy(json, {
      account: accounts[0],
      args: [token.target],
    });

    // mint token to users
    for (let i = 1; i <= 2; i++) {
      const user = accounts[i];
      await token.mint(user.address, 100n * 10n ** 18n);
      await token.connect(user).approve(vault.target, 100n * 10n ** 18n);
    }
  });

  describe("deposit", () => {
    it("deposit when total supply = 0", async () => {
      const user = accounts[1];
      await vault.connect(user).deposit(10n * 10n ** 18n);

      bigIntEq(
        await token.balanceOf(user.address),
        90n * 10n ** 18n,
        "token balance of user"
      );
      bigIntEq(
        await token.balanceOf(vault.target),
        10n * 10n ** 18n,
        "token balance of vault"
      );
      bigIntEq(
        await vault.balanceOf(user.address),
        10n * 10n ** 18n,
        "balanceOf"
      );
      bigIntEq(await vault.totalSupply(), 10n * 10n ** 18n, "totalSupply");
    });

    it("deposit - when total supply > 0", async () => {
      const user = accounts[2];
      await vault.connect(user).deposit(40n * 10n ** 18n);

      bigIntEq(
        await token.balanceOf(user.address),
        60n * 10n ** 18n,
        "token balance of user"
      );
      bigIntEq(
        await token.balanceOf(vault.target),
        50n * 10n ** 18n,
        "token balance of vault"
      );
      bigIntEq(
        await vault.balanceOf(user.address),
        40n * 10n ** 18n,
        "balanceOf"
      );
      bigIntEq(await vault.totalSupply(), 50n * 10n ** 18n, "totalSupply");
    });
  });

  describe("withdraw", () => {
    it("withdraw", async () => {
      // send some token
      await token.mint(vault.target, 50n * 10n ** 18n);

      // user 1
      await vault.connect(accounts[1]).withdraw(10n * 10n ** 18n);

      bigIntEq(
        await token.balanceOf(accounts[1].address),
        110n * 10n ** 18n,
        "token balance of user"
      );
      bigIntEq(
        await token.balanceOf(vault.target),
        80n * 10n ** 18n,
        "token balance of vault"
      );
      bigIntEq(await vault.balanceOf(accounts[1].address), 0n, "balanceOf");
      bigIntEq(await vault.totalSupply(), 40n * 10n ** 18n, "totalSupply");

      // user 2
      await vault.connect(accounts[2]).withdraw(40n * 10n ** 18n);

      bigIntEq(
        await token.balanceOf(accounts[2].address),
        140n * 10n ** 18n,
        "token balance of user"
      );
      bigIntEq(
        await token.balanceOf(vault.target),
        0n,
        "token balance of vault"
      );
      bigIntEq(await vault.balanceOf(accounts[2].address), 0n, "balanceOf");
      bigIntEq(await vault.totalSupply(), 0n, "totalSupply");
    });
  });
});

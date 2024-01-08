const { ethers } = require("hardhat");
const { expect, getContract, deploy, sendTx, bigIntEq } = require("./setup");
const { ETHER, findLog } = require("./utils");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-075.json`),
  "sol-075.sol",
  "WETH"
);

describe("WETH", () => {
  let accounts = [];
  let weth;

  before(async () => {
    accounts = await ethers.getSigners();
    weth = await deploy(json, { account: accounts[0] });
  });

  it("constructor", async () => {
    expect(await weth.name()).to.equal("Wrapped Ether");
    expect(await weth.symbol()).to.equal("WETH");
    expect(await weth.decimals()).to.equal(18);
  });

  it("deposit", async () => {
    const tx = await sendTx(weth.deposit({ value: ETHER }));

    bigIntEq(
      await weth.balanceOf(accounts[0].address),
      ETHER,
      "WETH balance of user"
    );
    bigIntEq(await weth.totalSupply(), ETHER, "WETH total supply");

    const log = findLog(tx, "Deposit");
    expect(log?.eventName).to.equal("Deposit");
    expect(log?.args?.account).to.equal(accounts[0].address);
    expect(log?.args?.amount).to.equal(ETHER);
  });

  it("fallback", async () => {
    await accounts[0].sendTransaction({
      to: weth.target,
      value: 1,
    });
    bigIntEq(
      await weth.balanceOf(accounts[0].address),
      ETHER + 1n,
      "WETH balance of user"
    );
  });

  it("withdraw", async () => {
    const ethBalBefore = await ethers.provider.getBalance(accounts[0].address);
    const bal = await weth.balanceOf(accounts[0].address);
    const tx = await sendTx(weth.withdraw(bal));
    const ethBalAfter = await ethers.provider.getBalance(accounts[0].address);

    bigIntEq(
      await weth.balanceOf(accounts[0].address),
      0n,
      "WETH balance of user"
    );
    bigIntEq(await weth.totalSupply(), 0n, "WETH total supply");
    expect(ethBalAfter).to.gt(ethBalBefore);

    const log = findLog(tx, "Withdraw");
    expect(log?.eventName).to.equal("Withdraw");
    expect(log?.args?.account).to.equal(accounts[0].address);
    expect(log?.args?.amount).to.equal(bal);
  });
});

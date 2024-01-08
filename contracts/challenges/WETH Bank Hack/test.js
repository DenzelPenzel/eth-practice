const { ethers } = require("hardhat");
const { getContract, deploy, bigIntEq } = require("./setup");
const { MAX_UINT } = require("./utils");

const WETH = getContract(require(`../build/WETH.json`), "WETH.sol", "WETH");

const ERC20_BANK = getContract(
  require(`../build/ERC20Bank.json`),
  "ERC20Bank.sol",
  "ERC20Bank"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-076.json`),
  "sol-076.sol",
  "ERC20BankExploit"
);

describe("ERC20BankExploit", () => {
  let contract;
  let accounts = [];
  let target;
  let weth;
  before(async () => {
    accounts = await ethers.getSigners();
    weth = await deploy(WETH, { account: accounts[0] });
    target = await deploy(ERC20_BANK, {
      account: accounts[0],
      args: [weth.target],
    });
    contract = await deploy(json, {
      account: accounts[1],
      args: [target.target],
    });

    await weth.connect(accounts[0]).deposit({
      value: 10n * 10n ** 18n,
    });
    await weth.connect(accounts[0]).approve(target.target, MAX_UINT);
    await target.connect(accounts[0]).deposit(10n ** 18n);
  });

  it("pwn", async () => {
    await contract.connect(accounts[1]).pwn(accounts[0].address);
    bigIntEq(
      await weth.balanceOf(accounts[0].address),
      0n,
      "weth balance of user"
    );
    bigIntEq(
      await weth.balanceOf(contract.target),
      9n * 10n ** 18n,
      "weth balance of exploit contract"
    );
  });
});

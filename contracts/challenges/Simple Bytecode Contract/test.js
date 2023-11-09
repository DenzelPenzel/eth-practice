const { ethers } = require("hardhat");
const {
  expect,
  getContract,
  getContractAt,
  deploy,
  sendTx,
  bigIntEq,
} = require("./setup");
const { findLog } = require("./utils");

const ICONTRACT = getContract(
  require(`../build/IContract.json`),
  "IContract.sol",
  "IContract"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-086.json`),
  "sol-086.sol",
  "Factory"
);

describe("Factory", () => {
  let contract;
  let accounts;

  before(async () => {
    accounts = await ethers.getSigners();
    contract = await deploy(json, { account: accounts[0] });
  });

  it("deploy", async () => {
    const tx = await sendTx(contract.deploy());

    const log = findLog(tx, "Log");
    expect(log?.eventName).to.equal("Log");

    const addr = log?.args?.addr;
    const test = await getContractAt(ICONTRACT, addr);

    bigIntEq(await test.test_42(), 42n);
    const code = await ethers.provider.getCode(addr);
    expect(code.length).to.lte(22);
  });
});

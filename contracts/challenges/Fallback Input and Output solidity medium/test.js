const { ethers } = require("hardhat");
const { expect, getContract, deploy, sendTx, bigIntEq } = require("./setup");
const { findLog } = require("./utils");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-088.json`),
  "sol-088.sol",
  "FallbackInputOutput"
);

const TestFallbackInputOutput = getContract(
  require(`../build/TestFallbackInputOutput.json`),
  "TestFallbackInputOutput.sol",
  "TestFallbackInputOutput"
);

const Counter = getContract(
  require(`../build/TestFallbackInputOutput.json`),
  "TestFallbackInputOutput.sol",
  "Counter"
);

describe("FallbackInputOutput", () => {
  let contract;
  let accounts;
  let testFallback;
  let counter;

  before(async () => {
    accounts = await ethers.getSigners();

    testFallback = await deploy(TestFallbackInputOutput, {
      account: accounts[0],
    });
    counter = await deploy(Counter, { account: accounts[0] });

    contract = await deploy(json, {
      account: accounts[0],
      args: [counter.target],
    });
  });

  it("fallback", async () => {
    // const data = await testFallback.getTestData()
    const data = "0x371303c0";

    const tx = await sendTx(testFallback.test(contract.target, data));

    const log = findLog(tx, "Log");
    expect(log?.eventName).to.equal("Log");
    expect(log?.args?.res).to.equal(
      "0x0000000000000000000000000000000000000000000000000000000000000001"
    );

    bigIntEq(await counter.count(), 1n, "Counter.count");
  });
});

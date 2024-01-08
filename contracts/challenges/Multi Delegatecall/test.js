const { ethers } = require("hardhat");
const { expect, getContract, deploy, sendTx } = require("./setup");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-071.json`),
  "sol-071.sol",
  "TestMultiDelegatecall"
);

describe("MultiDelegatecall", () => {
  let contract;
  let accounts = [];
  before(async () => {
    accounts = await ethers.getSigners();
    contract = await deploy(json, { account: accounts[0] });
  });

  it("fail if delegatecall fails", async () => {
    const data = ["0x00"];
    await expect(contract.multiDelegatecall(data)).to.be.reverted;
  });

  it("multi deletegatecall", async () => {
    const addrs = [];
    const data = [
      contract.interface.encodeFunctionData("func1", [1, 2]),
      contract.interface.encodeFunctionData("func2", []),
    ];

    const tx = await sendTx(contract.multiDelegatecall(data));

    expect(tx.logs.length).to.equal(2);

    expect(tx.logs[0].eventName).to.equal("Log");
    expect(tx.logs[0].args?.caller).to.equal(accounts[0].address);
    expect(tx.logs[0].args?.func).to.equal("func1");
    expect(tx.logs[0].args?.i).to.equal(3);

    expect(tx.logs[1].eventName).to.equal("Log");
    expect(tx.logs[1].args?.caller).to.equal(accounts[0].address);
    expect(tx.logs[1].args?.func).to.equal("func2");
    expect(tx.logs[1].args?.i).to.equal(2);
  });
});

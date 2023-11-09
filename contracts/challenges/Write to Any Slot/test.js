const { ethers } = require("hardhat");
const { expect, getContract, deploy } = require("./setup");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-089.json`),
  "sol-089.sol",
  "TestSlot"
);

const TEST_SLOT =
  "0xa7cb26ea17989bb9c5eb391c94c40892dcdc94bb4c381353450910ba80883e1c";

describe("TestSlot", () => {
  let contract;
  let accounts;

  before(async () => {
    accounts = await ethers.getSigners();
    contract = await deploy(json, { account: accounts[0] });
  });

  it("write", async () => {
    // const slot = await contract.TEST_SLOT()
    // console.log(slot)

    await contract.write(accounts[0].address);
    const data = await ethers.provider.getStorage(contract.target, TEST_SLOT);

    // skip 2 + 12 bytes
    expect(`0x${data.slice(26)}`).to.equal(accounts[0].address.toLowerCase());
  });

  it("get", async () => {
    expect(await contract.get()).to.equal(accounts[0].address);
  });
});

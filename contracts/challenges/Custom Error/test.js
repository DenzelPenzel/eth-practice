const { ethers } = require("hardhat");
const { expect, getContract, deploy } = require("./setup");
const { ZERO_ADDRESS } = require("./utils");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-087.json`),
  "sol-087.sol",
  "CustomError"
);

describe("CustomError", () => {
  let contract;
  let accounts;

  before(async () => {
    accounts = await ethers.getSigners();
    contract = await deploy(json, { account: accounts[0] });
  });

  it("setOwner invalid address", async () => {
    await expect(contract.setOwner(ZERO_ADDRESS)).to.be.revertedWithCustomError(
      contract,
      "InvalidAddress"
    );
  });

  it("setOwner not authorized", async () => {
    await expect(contract.connect(accounts[1]).setOwner(accounts[1].address))
      .to.be.revertedWithCustomError(contract, "NotAuthorized")
      .withArgs(accounts[1].address);
  });

  it("setOwner", async () => {
    await contract.connect(accounts[0]).setOwner(accounts[1].address);
    expect(await contract.owner()).to.equal(accounts[1].address);
  });
});

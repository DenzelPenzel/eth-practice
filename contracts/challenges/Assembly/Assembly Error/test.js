const { ethers } = require("hardhat");
const { getContract, deploy, expect } = require("./setup");
const { rand } = require("./utils");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-095.json`),
  "sol-095.sol",
  "AssemblyError"
);

describe("AssemblyError", () => {
  let yul;
  let accounts = [];
  before(async () => {
    accounts = await ethers.getSigners();
    yul = await deploy(json, { account: accounts[0] });
  });

  it("revert_if_zero", async () => {
    const x = rand(1, 10);
    await yul.revert_if_zero(x);

    await expect(yul.revert_if_zero(0)).to.be.reverted;
  });
});

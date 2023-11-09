const { ethers } = require("hardhat");
const { getContract, deploy, bigIntEq } = require("./setup");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-082.json`),
  "sol-082.sol",
  "BitwiseOps"
);

describe("BitwiseOps", () => {
  let contract;
  let accounts = [];

  before(async () => {
    accounts = await ethers.getSigners();
    contract = await deploy(json, { account: accounts[0] });
  });

  it("getLastNBits", async () => {
    bigIntEq(await contract.getLastNBits(13, 3), 5n, "last 3 bits of 13 != 5");
    bigIntEq(await contract.getLastNBits(1, 2), 1n, "last 2 bits of 1 != 1");
    bigIntEq(await contract.getLastNBits(0, 5), 0n, "last 5 bits of 0 != 0");
    bigIntEq(await contract.getLastNBits(0, 1), 0n, "last 1 bits of 0 != 0");
    bigIntEq(
      await contract.getLastNBits(10, 4),
      10n,
      "last 4 bits of 10 != 10"
    );
  });
});

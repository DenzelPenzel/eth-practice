const { ethers } = require("hardhat");
const { getContract, deploy, bigIntEq } = require("./setup");
const { MAX_UINT } = require("./utils");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-083.json`),
  "sol-083.sol",
  "MostSignificantBit"
);

describe("MostSignificantBit", () => {
  let contract;
  let accounts = [];

  before(async () => {
    accounts = await ethers.getSigners();
    contract = await deploy(json, { account: accounts[0] });
  });

  it("findMostSignificantBit", async () => {
    bigIntEq(
      await contract.findMostSignificantBit(0),
      0n,
      "most significant bit of 0"
    );
    bigIntEq(
      await contract.findMostSignificantBit(1),
      0n,
      "most significant bit of 1"
    );
    bigIntEq(
      await contract.findMostSignificantBit(2),
      1n,
      "most significant bit of 2"
    );
    bigIntEq(
      await contract.findMostSignificantBit(7),
      2n,
      "most significant bit of 7"
    );
    bigIntEq(
      await contract.findMostSignificantBit(8),
      3n,
      "most significant bit of 8"
    );
    bigIntEq(
      await contract.findMostSignificantBit(9),
      3n,
      "most significant bit of 9"
    );
    bigIntEq(
      await contract.findMostSignificantBit(15),
      3n,
      "most significant bit of 15"
    );
    bigIntEq(
      await contract.findMostSignificantBit(16),
      4n,
      "most significant bit of 16"
    );
    bigIntEq(
      await contract.findMostSignificantBit(17),
      4n,
      "most significant bit of 17"
    );
    bigIntEq(
      await contract.findMostSignificantBit(MAX_UINT),
      255n,
      "most significant bit of 2 ** 256 - 1"
    );
  });
});

const { ethers } = require("hardhat");
const { getContract, deploy, bigIntEq } = require("./setup");
const { rand } = require("./utils");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-094.json`),
  "sol-094.sol",
  "AssemblyIf"
);

describe("AssemblyIf", () => {
  let yul;
  let accounts = [];
  before(async () => {
    accounts = await ethers.getSigners();
    yul = await deploy(json, { account: accounts[0] });
  });

  it("min", async () => {
    const x = rand(1, 10);
    const y = rand(1, 10);

    if (x <= y) {
      bigIntEq(await yul.min(x, y), x, "x != min");
    } else {
      bigIntEq(await yul.min(x, y), y, "y != min");
    }
  });

  it("max", async () => {
    const x = rand(1, 10);
    const y = rand(1, 10);

    if (x >= y) {
      bigIntEq(await yul.max(x, y), x, "x != max");
    } else {
      bigIntEq(await yul.max(x, y), y, "y != max");
    }
  });
});

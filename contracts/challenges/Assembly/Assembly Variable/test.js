const { ethers } = require("hardhat");
const { getContract, deploy, bigIntEq } = require("./setup");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-093.json`),
  "sol-093.sol",
  "AssemblyVariable"
);

describe("AssemblyVariable", () => {
  let yul;
  let accounts = [];
  before(async () => {
    accounts = await ethers.getSigners();
    yul = await deploy(json, { account: accounts[0] });
  });

  it("hello", async () => {
    bigIntEq(await yul.hello(), 123, "z != 123");
  });
});

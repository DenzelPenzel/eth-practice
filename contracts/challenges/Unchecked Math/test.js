const { ethers } = require("hardhat");
const { getContract, deploy, bigIntEq } = require("./setup");
const { MAX_UINT } = require("./utils");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-085.json`),
  "sol-085.sol",
  "UncheckedMath"
);

describe("UncheckedMath", () => {
  let contract;
  let accounts;

  before(async () => {
    accounts = await ethers.getSigners();
    contract = await deploy(json, { account: accounts[0] });
  });

  it("sub", async () => {
    bigIntEq(await contract.sub(5, 1), 4n, "sub");
    bigIntEq(await contract.sub(0, 3), MAX_UINT - 2n, "sub");
  });

  it("sumOfCubes", async () => {
    bigIntEq(await contract.sumOfCubes(2, 3), 35n, "sum of cubes");
    bigIntEq(await contract.sumOfCubes(1, MAX_UINT), 0n, "sum of cubes");
  });
});

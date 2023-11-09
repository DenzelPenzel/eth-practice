const { ethers } = require("hardhat");
const { getContract, deploy, expect, bigIntEq } = require("./setup");
const { rand } = require("./utils");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-097.json`),
  "sol-097.sol",
  "AssemblyMath"
);

describe("AssemblyMath", () => {
  let yul;
  let accounts = [];
  before(async () => {
    accounts = await ethers.getSigners();
    yul = await deploy(json, { account: accounts[0] });
  });

  it("sub", async () => {
    await expect(yul.sub(1, 3)).to.be.reverted;
    bigIntEq(await yul.sub(3, 1), 2);
  });

  it("fixed_point_mul", async () => {
    const b = 100n;
    const x = rand(1, 9) * b;
    const y = rand(1, 9) * b;

    bigIntEq(await yul.fixed_point_mul(0, y, b), 0, "mul by 0");
    bigIntEq(await yul.fixed_point_mul(x, y, b), (x * y) / b, `${x} * ${y}`);
    bigIntEq(await yul.fixed_point_mul(b, b, b), b, "b * b");
    bigIntEq(await yul.fixed_point_mul(1, b, b), 1, "1 * b");
  });
});

const { ethers } = require("hardhat");
const { getContract, deploy, bigIntEq } = require("./setup");
const { rand } = require("./utils");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-098.json`),
  "sol-098.sol",
  "AssemblyBinExp"
);

describe("AssemblyBinExp", () => {
  let yul;
  let accounts = [];
  before(async () => {
    accounts = await ethers.getSigners();
    yul = await deploy(json, { account: accounts[0] });
  });

  it("rpow", async () => {
    const b = 100n;
    const x = rand(1, 9) * b;
    const n = rand(10, 30);

    bigIntEq(await yul.rpow(0, 0, b), b, "0**0");
    bigIntEq(await yul.rpow(0, n, b), 0, "0**n");

    bigIntEq(await yul.rpow(x, 0, b), b, `${x}**0`);
    bigIntEq(await yul.rpow(x, 1, b), x, `${x}**1`);
    bigIntEq(await yul.rpow(x, 2, b), (x / b) ** 2n * b, `${x}**2`);
    bigIntEq(await yul.rpow(x, 3, b), (x / b) ** 3n * b, `${x}**3`);
    bigIntEq(await yul.rpow(x, 4, b), (x / b) ** 4n * b, `${x}**4`);
    bigIntEq(await yul.rpow(x, 5, b), (x / b) ** 5n * b, `${x}**5`);
    bigIntEq(await yul.rpow(x, 6, b), (x / b) ** 6n * b, `${x}**6`);
    bigIntEq(await yul.rpow(x, 7, b), (x / b) ** 7n * b, `${x}**7`);
    bigIntEq(await yul.rpow(x, 8, b), (x / b) ** 8n * b, `${x}**8`);
    bigIntEq(await yul.rpow(x, 9, b), (x / b) ** 9n * b, `${x}**9`);
    bigIntEq(await yul.rpow(x, n, b), (x / b) ** n * b, `${x}**${n}`);
  });
});

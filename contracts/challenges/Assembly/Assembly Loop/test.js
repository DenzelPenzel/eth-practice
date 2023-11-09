const { ethers } = require("hardhat");
const { getContract, deploy, expect, bigIntEq } = require("./setup");
const { rand } = require("./utils");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-096.json`),
  "sol-096.sol",
  "AssemblyLoop"
);

describe("AssemblyLoop", () => {
  let yul;
  let accounts = [];
  before(async () => {
    accounts = await ethers.getSigners();
    yul = await deploy(json, { account: accounts[0] });
  });

  it("sum", async () => {
    bigIntEq(await yul.sum(0), 0, "sum != 0");

    const n = rand(2, 10);
    bigIntEq(await yul.sum(n), (n * (n - 1n)) / 2n, `sum(${n})`);
  });

  it("pow2k", async () => {
    // x = 0
    await expect(yul.pow2k(0, 0)).to.be.reverted;
    // n != 2**k
    await expect(yul.pow2k(1, 3)).to.be.reverted;
    await expect(yul.pow2k(1, 6)).to.be.reverted;

    const x = rand(2, 5);
    const k = rand(1, 5);
    const n = 2n ** k;

    bigIntEq(await yul.pow2k(1, 0), 1, "pow2k(1, 0) != 1");
    bigIntEq(await yul.pow2k(1, n), 1, "pow2k(1, n) != 1");
    bigIntEq(await yul.pow2k(x, 0), 1, "pow2k(x, 0) != 1");
    bigIntEq(await yul.pow2k(x, 2), x ** 2n, `pow2k(x, 2) != ${x}**2`);
    bigIntEq(await yul.pow2k(x, 4), x ** 4n, `pow2k(x, 4) != ${x}**4`);
    bigIntEq(await yul.pow2k(x, 8), x ** 8n, `pow2k(x, 8) != ${x}**8`);
    bigIntEq(await yul.pow2k(x, n), x ** n, `pow2k(x, n) != ${x}**${n}`);
  });
});

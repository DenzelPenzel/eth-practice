const { ethers } = require("hardhat");
const { getContract, deploy } = require("./setup");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-081.json`),
  "sol-081.sol",
  "Token"
);

describe("Token", () => {
  let token;
  let accounts = [];

  before(async () => {
    accounts = await ethers.getSigners();
    token = await deploy(json, { account: accounts[0] });
  });

  it("Debug with hardhat/console", async () => {
    await token.connect(accounts[0]).transfer(accounts[1].address, 50);
  });
});

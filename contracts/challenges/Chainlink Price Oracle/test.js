const { ethers } = require("hardhat");
const { expect, getContract, getContractAt, deploy } = require("./setup");
const { format, log, getTimestamp } = require("./utils");
const { BTC_USD } = require("./config");

const AggregatorV3Interface = getContract(
  require(`../build/AggregatorV3Interface.json`),
  "AggregatorV3Interface.sol",
  "AggregatorV3Interface"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/chainlink-001.json`),
  "chainlink-001.sol",
  "PriceOracle"
);

describe("PriceOracle", () => {
  let contract;
  let accounts = [];
  let agg;

  before(async () => {
    accounts = await ethers.getSigners();
    contract = await deploy(json, { account: accounts[0] });

    agg = getContractAt(AggregatorV3Interface, BTC_USD);
  });

  it("getPrice", async () => {
    const { updatedAt } = await agg.latestRoundData();
    const now = getTimestamp();

    if (updatedAt < BigInt(now - 24 * 3600)) {
      await expect(contract.getPrice()).to.be.reverted;
    } else {
      const price = await contract.getPrice();

      log(`1 BTC = ${format(price)} USD`);
      expect(price).to.gte(0);
    }
  });
});

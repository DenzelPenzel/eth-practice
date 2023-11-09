const { ethers } = require("hardhat");
const { expect, getContract, getContractAt, deploy } = require("./setup");
const { format, log } = require("./utils");
const { WETH } = require("./config");

const IWETH = getContract(require(`../build/IWETH.json`), "IWETH.sol", "IWETH");
const IUniswapV2Pair = getContract(
  require(`../build/IUniswapV2Pair.json`),
  "IUniswapV2Pair.sol",
  "IUniswapV2Pair"
);
const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/uniswap-v2-004.json`),
  "uniswap-v2-004.sol",
  "UniswapV2FlashSwap"
);

const PAIR = "0xA478c2975Ab1Ea89e8196811F51A7B7Ade33eB11";
const WETH_MAX_FEE = 1n * 10n ** 18n;
const WETH_BORROW_AMOUNT = 100n * 10n ** 18n;

describe("UniswapV2FlashSwap", () => {
  let contract;
  let accounts = [];
  let user;
  let weth;
  let pair;

  before(async () => {
    accounts = await ethers.getSigners();
    contract = await deploy(json, { account: accounts[0] });

    weth = getContractAt(IWETH, WETH);
    pair = getContractAt(IUniswapV2Pair, PAIR);

    user = accounts[0];

    await weth.connect(user).deposit({ value: WETH_MAX_FEE });
    await weth.connect(user).approve(contract.target, WETH_MAX_FEE);
  });

  it("fails if msg.sender is not pair", async () => {
    const data = ethers.AbiCoder.defaultAbiCoder().encode(
      ["address", "address"],
      [WETH, user.address]
    );
    await expect(
      contract.connect(user).uniswapV2Call(contract.target, 0, 0, data)
    ).to.be.reverted;
  });

  it("fails if sender not this contract", async () => {
    const data = ethers.AbiCoder.defaultAbiCoder().encode(
      ["address", "address"],
      [WETH, user.address]
    );
    await expect(pair.connect(user).swap(0, 1, contract.target, data)).to.be
      .reverted;
  });

  it("flashSwap", async () => {
    log(`Flash swap ${format(WETH_BORROW_AMOUNT)} WETH`);

    const snapshot = async () => {
      return {
        weth: await weth.balanceOf(user.address),
      };
    };

    const s0 = await snapshot();
    await contract.connect(user).flashSwap(WETH_BORROW_AMOUNT);
    const s1 = await snapshot();

    const fee = s0.weth - s1.weth;
    log(`Flash swap fee ${format(fee)}`);

    expect(fee).to.gt(0);
  });
});

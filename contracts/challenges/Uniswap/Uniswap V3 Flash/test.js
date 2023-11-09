const { ethers } = require("hardhat");
const {
  expect,
  bigIntEq,
  getContract,
  getContractAt,
  deploy,
} = require("./setup");
const { format, log } = require("./utils");
const { WETH, DAI_WETH_POOL } = require("./config");

const IWETH = getContract(require(`../build/IWETH.json`), "IWETH.sol", "IWETH");
const IUniswapV3Pool = getContract(
  require(`../build/IUniswapV3Pool.json`),
  "IUniswapV3Pool.sol",
  "IUniswapV3Pool"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/uniswap-v3-004.json`),
  "uniswap-v3-004.sol",
  "UniswapV3Flash"
);

const WETH_AMOUNT = 10n * 10n ** 18n;
const FEE = 10n ** 18n;

describe("UniswapV3Flash", () => {
  let contract;
  let accounts = [];
  let user;
  let weth;
  let pool;

  before(async () => {
    accounts = await ethers.getSigners();
    user = accounts[0];

    contract = await deploy(json, { account: accounts[0] });
    pool = getContractAt(IUniswapV3Pool, DAI_WETH_POOL);
    weth = getContractAt(IWETH, WETH);

    await weth.connect(user).deposit({ value: FEE });
    await weth.connect(user).approve(contract.target, FEE);
  });

  it("uniswapV3FlashCallback - only pool can call", async () => {
    await expect(
      contract.connect(user).uniswapV3FlashCallback(0, 0, "0x")
    ).to.be.revertedWith("not authorized");
  });

  it("flash", async () => {
    const snapshot = async () => {
      return {
        feeGrowthGlobal1X128: await pool.feeGrowthGlobal1X128(),
        weth: await weth.balanceOf(pool.target),
      };
    };

    log(`Flash borrow ${format(WETH_AMOUNT)} WETH`);

    const s0 = await snapshot();
    await contract.connect(user).flash(WETH_AMOUNT);
    const s1 = await snapshot();

    log(`Paid ${format(s1.weth - s0.weth)} WETH for fee on borrow`);

    expect(s1.feeGrowthGlobal1X128).to.gt(s0.feeGrowthGlobal1X128);

    bigIntEq(
      await weth.balanceOf(contract.target),
      0,
      "WETH balance of contract"
    );
  });
});

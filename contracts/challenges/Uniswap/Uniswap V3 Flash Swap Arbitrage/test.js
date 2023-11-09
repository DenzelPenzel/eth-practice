const { ethers } = require("hardhat");
const {
  expect,
  bigIntEq,
  getContract,
  getContractAt,
  deploy,
} = require("./setup");
const { format, log } = require("./utils");
const {
  WETH,
  USDC,
  USDC_WETH_POOL_3000,
  USDC_WETH_POOL_500,
} = require("./config");

const IWETH = getContract(require(`../build/IWETH.json`), "IWETH.sol", "IWETH");
const IUniswapV3Pool = getContract(
  require(`../build/IUniswapV3Pool.json`),
  "IUniswapV3Pool.sol",
  "IUniswapV3Pool"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/uniswap-v3-005.json`),
  "uniswap-v3-005.sol",
  "UniswapV3FlashSwap"
);

const WETH_FLASH_SWAP_AMOUNT = 10n * 10n ** 18n;
const WETH_MAX_FEE = 10n ** 18n;

describe("UniswapV3FlashSwap", () => {
  let contract;
  let accounts = [];
  let user;
  let weth;
  let pool0;
  let pool1;
  const FEE_0 = 3000n;
  const FEE_1 = 500n;

  before(async () => {
    accounts = await ethers.getSigners();
    user = accounts[0];

    contract = await deploy(json, { account: accounts[0] });
    pool0 = getContractAt(IUniswapV3Pool, USDC_WETH_POOL_3000);
    pool1 = getContractAt(IUniswapV3Pool, USDC_WETH_POOL_500);
    weth = getContractAt(IWETH, WETH);

    await weth.connect(user).deposit({ value: WETH_MAX_FEE });
    await weth.connect(user).approve(contract.target, WETH_MAX_FEE);
  });

  it("flashSwap", async () => {
    const snapshot = async () => {
      return {
        weth: await weth.balanceOf(user.address),
        pool0: {
          fee1: await pool0.feeGrowthGlobal1X128(),
        },
        pool1: {
          fee0: await pool1.feeGrowthGlobal0X128(),
        },
      };
    };

    log(`Flash swap ${format(WETH_FLASH_SWAP_AMOUNT)} WETH`);

    const s0 = await snapshot();
    await contract
      .connect(user)
      .flashSwap(pool0.target, FEE_1, WETH_FLASH_SWAP_AMOUNT);
    const s1 = await snapshot();

    if (s1.weth >= s0.weth) {
      log(`${format(s1.weth - s0.weth)} WETH profit`);
    } else {
      log(`${format(s0.weth - s1.weth)} WETH loss`);
    }

    expect(s1.pool0.fee1).to.gt(s0.pool0.fee1);
    expect(s1.pool1.fee0).to.gt(s0.pool1.fee0);
  });
});

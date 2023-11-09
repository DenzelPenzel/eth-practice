const { ethers } = require("hardhat");
const {
  expect,
  getContract,
  getContractAt,
  deploy,
  bigIntEq,
} = require("./setup");
const { format, log } = require("./utils");
const { WETH, DAI } = require("./config");

const IWETH = getContract(require(`../build/IWETH.json`), "IWETH.sol", "IWETH");
const IERC20 = getContract(
  require(`../build/IERC20.json`),
  "IERC20.sol",
  "IERC20"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/uniswap-v2-001.json`),
  "uniswap-v2-001.sol",
  "UniswapV2SingleHopSwap"
);

const AMOUNT_IN = 10n ** 18n;
const AMOUNT_OUT = 3n * 10n ** 18n;
const AMOUNT_IN_MAX = 10n ** 18n;

describe("UniswapV2SingleHopSwap", () => {
  let contract;
  let accounts = [];
  let user;
  let weth;
  let dai;

  before(async () => {
    accounts = await ethers.getSigners();
    contract = await deploy(json, { account: accounts[0] });

    user = accounts[0];

    weth = getContractAt(IWETH, WETH);
    dai = getContractAt(IERC20, DAI);

    await weth.connect(user).deposit({ value: AMOUNT_IN + AMOUNT_IN_MAX });
    await weth
      .connect(user)
      .approve(contract.target, AMOUNT_IN + AMOUNT_IN_MAX);
  });

  it("swapSingleHopExactAmountIn", async () => {
    log(`Swapping ${format(AMOUNT_IN)} WETH to DAI`);

    await contract.connect(user).swapSingleHopExactAmountIn(AMOUNT_IN, 1);

    const daiBal = await dai.balanceOf(user.address);
    log(`Received ${format(daiBal)} DAI`);
    expect(daiBal).to.gt(0);
  });

  it("swapSingleHopExactAmountOut", async () => {
    log(
      `Swapping max ${format(AMOUNT_IN_MAX)} WETH for ${format(
        AMOUNT_OUT,
        18
      )} DAI`
    );

    const snapshot = async () => {
      return {
        dai: await dai.balanceOf(user.address),
        weth: await weth.balanceOf(user.address),
      };
    };

    const s0 = await snapshot();
    await contract
      .connect(user)
      .swapSingleHopExactAmountOut(AMOUNT_OUT, AMOUNT_IN_MAX);
    const s1 = await snapshot();

    const wethIn = s0.weth - s1.weth;
    const daiOut = s1.dai - s0.dai;

    log(`Spent ${format(wethIn)} WETH`);
    log(`Received ${format(daiOut)} DAI`);

    expect(wethIn).to.lte(AMOUNT_IN_MAX);
    bigIntEq(daiOut, AMOUNT_OUT, "DAI received");
    bigIntEq(
      await weth.balanceOf(contract.target),
      0,
      "WETH balance of contract"
    );
  });
});

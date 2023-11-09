const { ethers } = require("hardhat");
const {
  expect,
  getContract,
  getContractAt,
  deploy,
  bigIntEq,
} = require("./setup");
const { format, log } = require("./utils");
const { WETH, DAI, ROUTER } = require("./config");

const IWETH = getContract(require(`../build/IWETH.json`), "IWETH.sol", "IWETH");
const IERC20 = getContract(
  require(`../build/IERC20.json`),
  "IERC20.sol",
  "IERC20"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/uniswap-v3-002.json`),
  "uniswap-v3-002.sol",
  "UniswapV3MultiHopSwap"
);

const AMOUNT_IN = 10n ** 18n;
const AMOUNT_OUT = 20n * 10n ** 18n;
const AMOUNT_IN_MAX = 10n ** 18n;

describe("UniswapV2MultiHopSwap", () => {
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

  it("swapExactInputMultiHop", async () => {
    log(`Swapping ${format(AMOUNT_IN)} WETH to DAI`);

    const snapshot = async () => {
      return {
        dai: await dai.balanceOf(user.address),
      };
    };

    const s0 = await snapshot();
    await contract.connect(user).swapExactInputMultiHop(AMOUNT_IN, 1);
    const s1 = await snapshot();

    const daiOut = s1.dai - s0.dai;
    log(`Received ${format(daiOut)} DAI`);
    expect(daiOut).to.gt(0);
  });

  it("swapExactOutputMultiHop", async () => {
    log(
      `Swapping max ${format(AMOUNT_IN_MAX)} WETH for ${format(
        AMOUNT_OUT,
        18
      )} DAI`
    );

    const snapshot = async () => {
      return {
        weth: await weth.balanceOf(user.address),
        dai: await dai.balanceOf(user.address),
      };
    };

    const s0 = await snapshot();
    await contract
      .connect(user)
      .swapExactOutputMultiHop(AMOUNT_OUT, AMOUNT_IN_MAX);
    const s1 = await snapshot();

    const wethIn = s0.weth - s1.weth;
    const daiOut = s1.dai - s0.dai;

    log(`Spent ${format(wethIn)} WETH`);
    log(`Received ${format(daiOut)} DAI`);

    expect(wethIn).lte(AMOUNT_IN_MAX);
    bigIntEq(daiOut, AMOUNT_OUT, "CRV received");
    bigIntEq(
      await weth.balanceOf(contract.target),
      0,
      "WETH balance of contract"
    );
    bigIntEq(
      await weth.allowance(contract.target, ROUTER),
      0,
      "WETH allowance of contract to router"
    );
  });
});

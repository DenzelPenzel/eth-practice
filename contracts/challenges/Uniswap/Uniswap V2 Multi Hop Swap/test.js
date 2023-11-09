const { ethers } = require("hardhat");
const {
  expect,
  getContract,
  getContractAt,
  deploy,
  bigIntEq,
  unlock,
} = require("./setup");
const { format, log } = require("./utils");
const { DAI, CRV, UNLOCK_ACCOUNT } = require("./config");

const IERC20 = getContract(
  require(`../build/IERC20.json`),
  "IERC20.sol",
  "IERC20"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/uniswap-v2-002.json`),
  "uniswap-v2-002.sol",
  "UniswapV2MultiHopSwap"
);

const AMOUNT_IN = 10n ** 18n;
const AMOUNT_OUT = 1n * 10n ** 17n;
const AMOUNT_IN_MAX = 10n * 10n ** 18n;

describe("UniswapV2MultiHopSwap", () => {
  let contract;
  let accounts = [];
  let user;
  let dai;
  let crv;

  before(async () => {
    accounts = await ethers.getSigners();
    contract = await deploy(json, { account: accounts[0] });

    user = await unlock(UNLOCK_ACCOUNT);

    await accounts[0].sendTransaction({
      to: UNLOCK_ACCOUNT,
      value: 100n * 10n ** 18n,
    });

    dai = getContractAt(IERC20, DAI);
    crv = getContractAt(IERC20, CRV);

    await dai.connect(user).approve(contract.target, AMOUNT_IN + AMOUNT_IN_MAX);
  });

  it("swapMultiHopExactAmountIn", async () => {
    log(`Swapping ${format(AMOUNT_IN)} DAI to CRV`);

    const snapshot = async () => {
      return {
        crv: await crv.balanceOf(user.address),
      };
    };

    const s0 = await snapshot();
    await contract.connect(user).swapMultiHopExactAmountIn(AMOUNT_IN, 1);
    const s1 = await snapshot();

    const crvOut = s1.crv - s0.crv;
    log(`Received ${format(crvOut)} CRV`);
    expect(crvOut).to.gt(0);
  });

  it("swapMultiHopExactAmountOut", async () => {
    log(
      `Swapping max ${format(AMOUNT_IN_MAX)} DAI for ${format(
        AMOUNT_OUT,
        18
      )} CRV`
    );

    const snapshot = async () => {
      return {
        crv: await crv.balanceOf(user.address),
        dai: await dai.balanceOf(user.address),
      };
    };

    const s0 = await snapshot();
    await contract
      .connect(user)
      .swapMultiHopExactAmountOut(AMOUNT_OUT, AMOUNT_IN_MAX);
    const s1 = await snapshot();

    const daiIn = s0.dai - s1.dai;
    const crvOut = s1.crv - s0.crv;

    log(`Spent ${format(daiIn)} DAI`);
    log(`Received ${format(crvOut)} CRV`);

    expect(daiIn).lte(AMOUNT_IN_MAX);
    bigIntEq(crvOut, AMOUNT_OUT, "CRV received");
    bigIntEq(
      await dai.balanceOf(contract.target),
      0,
      "DAI balance of contract"
    );
  });
});

const { ethers } = require("hardhat");
const {
  expect,
  getContract,
  getContractAt,
  deploy,
  unlock,
  bigIntEq,
} = require("./setup");
const { format, log } = require("./utils");
const { WETH, DAI, DAI_WETH_PAIR, UNLOCK_ACCOUNT } = require("./config");

const IWETH = getContract(require(`../build/IWETH.json`), "IWETH.sol", "IWETH");
const IERC20 = getContract(
  require(`../build/IERC20.json`),
  "IERC20.sol",
  "IERC20"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/uniswap-v2-003.json`),
  "uniswap-v2-003.sol",
  "UniswapV2Liquidity"
);

const WETH_AMOUNT = 10n ** 18n;
const DAI_AMOUNT = 5n * 10n ** 18n;

describe("UniswapV2Liquidity", () => {
  let contract;
  let accounts = [];
  let user;
  let weth;
  let dai;
  let pair;

  before(async () => {
    accounts = await ethers.getSigners();
    contract = await deploy(json, { account: accounts[0] });

    weth = getContractAt(IWETH, WETH);
    dai = getContractAt(IERC20, DAI);
    pair = getContractAt(IERC20, DAI_WETH_PAIR);

    user = await unlock(UNLOCK_ACCOUNT);

    await accounts[0].sendTransaction({
      to: UNLOCK_ACCOUNT,
      value: 100n * 10n ** 18n,
    });

    await weth.connect(user).deposit({ value: WETH_AMOUNT });
    await weth.connect(user).approve(contract.target, WETH_AMOUNT);
    await dai.connect(user).approve(contract.target, DAI_AMOUNT);
  });

  it("addLiquidity", async () => {
    log(
      `Adding liquidity ${format(WETH_AMOUNT)} WETH and ${format(
        DAI_AMOUNT
      )} DAI`
    );

    await contract.connect(user).addLiquidity(WETH_AMOUNT, DAI_AMOUNT);

    const lpAmount = await pair.balanceOf(user.address);
    log(`Received ${format(lpAmount)} liquidity token`);

    expect(lpAmount).to.gt(0);

    bigIntEq(
      await weth.balanceOf(contract.target),
      0,
      "WETH balance of contract"
    );
    bigIntEq(
      await dai.balanceOf(contract.target),
      0,
      "DAI balance of contract"
    );
  });

  it("removeLiquidity", async () => {
    const snapshot = async () => {
      return {
        dai: await dai.balanceOf(user.address),
        weth: await weth.balanceOf(user.address),
        pair: await pair.balanceOf(user.address),
      };
    };

    const s0 = await snapshot();
    log(`Removing liquidity ${format(s0.pair)} liquidity token...`);

    await pair.connect(user).approve(contract.target, s0.pair);
    await contract.connect(user).removeLiquidity(s0.pair);

    const s1 = await snapshot();

    log(`${format(s1.weth - s0.weth)} WETH received`);
    log(`${format(s1.dai - s0.dai)} DAI received`);

    bigIntEq(s1.pair, 0, "Liquidity token balance of user != 0");
    expect(s1.weth).to.gt(s0.weth);
    expect(s1.dai).to.gt(s0.dai);
  });
});

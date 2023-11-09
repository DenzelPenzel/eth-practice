const { ethers } = require("hardhat");
const {
  expect,
  bigIntEq,
  getContract,
  getContractAt,
  deploy,
  sendTx,
  unlock,
} = require("./setup");
const { format, log, findLog, MAX_UINT } = require("./utils");
const {
  WETH,
  DAI,
  UNLOCK_ACCOUNT,
  DAI_WETH_POOL,
  MANAGER,
} = require("./config");

const IWETH = getContract(require(`../build/IWETH.json`), "IWETH.sol", "IWETH");
const IERC20 = getContract(
  require(`../build/IERC20.json`),
  "IERC20.sol",
  "IERC20"
);
const IUniswapV3Pool = getContract(
  require(`../build/IUniswapV3Pool.json`),
  "IUniswapV3Pool.sol",
  "IUniswapV3Pool"
);
const INonfungiblePositionManager = getContract(
  require(`../build/INonfungiblePositionManager.json`),
  "INonfungiblePositionManager.sol",
  "INonfungiblePositionManager"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/uniswap-v3-003.json`),
  "uniswap-v3-003.sol",
  "UniswapV3Liquidity"
);

// Mint
const WETH_AMOUNT = 10n ** 17n;
const DAI_AMOUNT = 2n * 10n ** 18n;
// Increase liquidity
const WETH_INC_AMOUNT = 10n ** 17n;
const DAI_INC_AMOUNT = 3n * 10n ** 18n;

describe("UniswapV3Liquidity", () => {
  let contract;
  let accounts = [];
  let user;
  let weth;
  let dai;
  let pool;
  let manager;
  let tokenId;

  before(async () => {
    accounts = await ethers.getSigners();
    user = await unlock(UNLOCK_ACCOUNT);

    await accounts[0].sendTransaction({
      to: UNLOCK_ACCOUNT,
      value: 100n * 10n ** 18n,
    });

    contract = await deploy(json, { account: accounts[0] });

    pool = getContractAt(IUniswapV3Pool, DAI_WETH_POOL);
    manager = getContractAt(INonfungiblePositionManager, MANAGER);

    weth = getContractAt(IWETH, WETH);
    dai = getContractAt(IERC20, DAI);

    await weth.connect(user).deposit({ value: WETH_AMOUNT + WETH_INC_AMOUNT });
    await weth.connect(user).approve(contract.target, MAX_UINT);
    await dai.connect(user).approve(contract.target, MAX_UINT);
  });

  it("mint", async () => {
    const snapshot = async () => {
      return {
        liquidity: await pool.liquidity(),
      };
    };

    log(
      `Minting new position ${format(WETH_AMOUNT)} WETH and ${format(
        DAI_AMOUNT
      )} DAI`
    );

    const s0 = await snapshot();
    const tx = await sendTx(
      contract.connect(user).mint(DAI_AMOUNT, WETH_AMOUNT)
    );
    const s1 = await snapshot();

    const event = findLog(tx, "Mint");
    expect(event?.eventName).to.equal("Mint");
    expect(event?.args?.tokenId).to.gt(0);

    tokenId = event?.args.tokenId;

    log(`Minted token id ${tokenId}`);
    log(`Added liquidity ${s1.liquidity - s0.liquidity}`);

    expect(s1.liquidity).to.gt(s0.liquidity);

    expect(await manager.ownerOf(tokenId)).to.equal(contract.target);

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
    bigIntEq(
      await weth.allowance(contract.target, MANAGER),
      0,
      "WETH allowance of contract to manager"
    );
    bigIntEq(
      await dai.allowance(contract.target, MANAGER),
      0,
      "DAI allowance of contract to manager"
    );
  });

  it("increaseLiquidity", async () => {
    const snapshot = async () => {
      return {
        liquidity: await pool.liquidity(),
      };
    };

    log(
      `Increasing liquidity ${format(WETH_INC_AMOUNT)} WETH and ${format(
        DAI_INC_AMOUNT
      )} DAI`
    );

    const s0 = await snapshot();
    await contract
      .connect(user)
      .increaseLiquidity(tokenId, DAI_INC_AMOUNT, WETH_INC_AMOUNT);
    const s1 = await snapshot();

    log(`Increased liquidity by ${s1.liquidity - s0.liquidity}`);
    expect(s1.liquidity).to.gt(s0.liquidity);

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
    bigIntEq(
      await weth.allowance(contract.target, MANAGER),
      0,
      "WETH allowance of contract to manager"
    );
    bigIntEq(
      await dai.allowance(contract.target, MANAGER),
      0,
      "DAI allowance of contract to manager"
    );
  });

  it("decreaseLiquidity", async () => {
    const snapshot = async () => {
      return {
        position: await manager.positions(tokenId),
      };
    };

    const s0 = await snapshot();
    log(`Decreasing liquidity by ${s0.position.liquidity}`);

    await contract
      .connect(user)
      .decreaseLiquidity(tokenId, s0.position.liquidity);
    const s1 = await snapshot();

    log(`Decreased liquidity to ${s1.position.liquidity}`);

    bigIntEq(s1.position.liquidity, 0, "Liquidity != 0");
    expect(s1.position.tokensOwed0).to.gt(s0.position.tokensOwed0);
    expect(s1.position.tokensOwed1).to.gt(s0.position.tokensOwed1);
  });

  it("collect", async () => {
    const snapshot = async () => {
      return {
        dai: await dai.balanceOf(user.address),
        weth: await weth.balanceOf(user.address),
      };
    };

    log(`Collecting tokens + fees`);

    const s0 = await snapshot();
    await contract.connect(user).collect(tokenId);
    const s1 = await snapshot();

    log(`Received ${format(s1.dai - s0.dai)} DAI`);
    log(`Received ${format(s1.weth - s0.weth)} WETH`);

    expect(s1.dai).to.gt(s0.dai);
    expect(s1.weth).to.gt(s0.weth);
  });
});

const { ethers } = require("hardhat");
const { getContract, deploy, bigIntEq } = require("./setup");

const TEST_TOKEN = getContract(
  require(`../build/TestToken.json`),
  "TestToken.sol",
  "TestToken"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-084.json`),
  "sol-084.sol",
  "DiscreteStakingRewards"
);

const REWARDS = [300n * 10n ** 18n];
const TOTAL_REWARDS = 300n * 10n ** 18n;
const STAKING_AMOUNTS = [2n * 10n ** 6n, 1n * 10n ** 6n];
const TOTAL_STAKED = 3n * 10n ** 6n;

describe("DiscreteStakingRewards", () => {
  let contract;
  let stakingToken;
  let rewardToken;
  let accounts = [];
  let users = [];

  before(async () => {
    accounts = await ethers.getSigners();
    users = [accounts[1], accounts[2]];

    stakingToken = await deploy(TEST_TOKEN, {
      account: accounts[0],
      args: ["stake", "STAKE", 6],
    });
    rewardToken = await deploy(TEST_TOKEN, {
      account: accounts[0],
      args: ["reward", "REWARD", 18],
    });

    contract = await deploy(json, {
      account: accounts[0],
      args: [stakingToken.target, rewardToken.target],
    });

    await rewardToken.mint(accounts[0].address, TOTAL_REWARDS);
    await rewardToken
      .connect(accounts[0])
      .approve(contract.target, TOTAL_REWARDS);

    for (let i = 0; i < users.length; i++) {
      const user = users[i];
      const amount = STAKING_AMOUNTS[i];

      stakingToken.mint(user.address, amount);
      stakingToken.connect(user).approve(contract.target, amount);
    }
  });

  it("stake", async () => {
    for (let i = 0; i < 2; i++) {
      const user = users[i];
      const amount = STAKING_AMOUNTS[i];

      const snapshot = async () => {
        return {
          balance: await contract.balanceOf(user.address),
          totalSupply: await contract.totalSupply(),
          stake: {
            user: await stakingToken.balanceOf(user.address),
            contract: await stakingToken.balanceOf(contract.target),
          },
        };
      };

      const s0 = await snapshot();
      await contract.connect(user).stake(amount);
      const s1 = await snapshot();

      bigIntEq(s1.balance, s0.balance + amount, "balance of user");
      bigIntEq(s1.totalSupply, s0.totalSupply + amount, "total supply");
      bigIntEq(
        s1.stake.user,
        s0.stake.user - amount,
        "staking token balance of user"
      );
      bigIntEq(
        s1.stake.contract,
        s0.stake.contract + amount,
        "staking token balance of contract"
      );
    }
  });

  it("updateRewardIndex", async () => {
    const snapshot = async () => {
      return {
        reward: await rewardToken.balanceOf(contract.target),
      };
    };

    const s0 = await snapshot();
    await contract.connect(accounts[0]).updateRewardIndex(REWARDS[0]);
    const s1 = await snapshot();

    bigIntEq(s1.reward, s0.reward + REWARDS[0], "reward balance");
  });

  it("unstake", async () => {
    for (let i = 0; i < 2; i++) {
      const user = users[i];
      const amount = STAKING_AMOUNTS[i];

      const snapshot = async () => {
        return {
          balance: await contract.balanceOf(user.address),
          totalSupply: await contract.totalSupply(),
          stake: {
            user: await stakingToken.balanceOf(user.address),
            contract: await stakingToken.balanceOf(contract.target),
          },
        };
      };

      const s0 = await snapshot();
      await contract.connect(user).unstake(amount);
      const s1 = await snapshot();

      bigIntEq(s1.balance, s0.balance - amount, "balance of user");
      bigIntEq(s1.totalSupply, s0.totalSupply - amount, "total supply");
      bigIntEq(
        s1.stake.user,
        s0.stake.user + amount,
        "staking token balance of user"
      );
      bigIntEq(
        s1.stake.contract,
        s0.stake.contract - amount,
        "staking token balance of contract"
      );
    }
  });

  it("calculateRewardsEarned", async () => {
    bigIntEq(
      await contract.calculateRewardsEarned(users[0].address),
      (REWARDS[0] * STAKING_AMOUNTS[0]) / TOTAL_STAKED,
      "user 0 rewards"
    );
    bigIntEq(
      await contract.calculateRewardsEarned(users[1].address),
      (REWARDS[0] * STAKING_AMOUNTS[1]) / TOTAL_STAKED,
      "user 1 rewards"
    );
  });

  it("claim", async () => {
    for (let i = 0; i < 2; i++) {
      const user = users[i];

      const snapshot = async () => {
        return {
          reward: {
            user: await rewardToken.balanceOf(user.address),
          },
        };
      };

      await contract.connect(user).claim();
      const s1 = await snapshot();

      bigIntEq(
        s1.reward.user,
        (REWARDS[0] * STAKING_AMOUNTS[i]) / TOTAL_STAKED,
        "rewards claimed"
      );
      bigIntEq(
        await contract.calculateRewardsEarned(user.address),
        0,
        "rewards earned"
      );
    }
  });
});

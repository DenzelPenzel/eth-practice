const { ethers } = require("hardhat");
const { expect, getContract, deploy, bigIntEq } = require("./setup");
const { skip, frac } = require("./utils");

const TEST_TOKEN = getContract(
  require(`../build/TestToken.json`),
  "TestToken.sol",
  "TestToken"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-080.json`),
  "sol-080.sol",
  "StakingRewards"
);

const DURATION = 7 * 24 * 3600;
const REWARD_AMOUNTS = [200n * 10n ** 18n, 100n * 10n ** 18n];
const STAKING_AMOUNTS = [100n * 10n ** 18n, 100n * 10n ** 18n];

describe("StakingRewards", () => {
  let stakingRewards;
  let accounts = [];
  let owner;
  let users = [];
  let stakingToken;
  let rewardsToken;

  before(async () => {
    accounts = await ethers.getSigners();
    owner = accounts[0];
    users = [accounts[1], accounts[2], accounts[3]];

    stakingToken = await deploy(TEST_TOKEN, {
      account: accounts[0],
      args: ["stake", "STAKE", 18],
    });
    rewardsToken = await deploy(TEST_TOKEN, {
      account: accounts[0],
      args: ["reward", "REWARD", 18],
    });

    stakingRewards = await deploy(json, {
      account: accounts[0],
      args: [stakingToken.target, rewardsToken.target],
    });

    for (let i = 0; i < users.length; i++) {
      const user = users[i];
      const amount = STAKING_AMOUNTS[i];

      stakingToken.mint(user.address, amount);
      stakingToken.connect(user).approve(stakingRewards.target, amount);
    }
  });

  describe("setRewardsDuration", () => {
    it("setRewardsDuration - fails if caller is not owner", async () => {
      await expect(stakingRewards.connect(users[0]).setRewardsDuration(0)).to.be
        .rejected;
    });

    it("setRewardsDuration", async () => {
      await stakingRewards.connect(owner).setRewardsDuration(DURATION);

      bigIntEq(await stakingRewards.duration(), DURATION, "reward duration");
    });
  });

  describe("notifyRewardAmount", () => {
    it("notifyRewardAmount - fails if caller is not owner", async () => {
      await expect(stakingRewards.connect(users[0]).notifyRewardAmount(0)).to.be
        .rejected;
    });

    it("notifyRewardAmount - fails if caller is not owner", async () => {
      await expect(stakingRewards.connect(users[0]).notifyRewardAmount(0)).to.be
        .rejected;
    });

    it("notifyRewardAmount - fails if reward rate = 0", async () => {
      await expect(stakingRewards.connect(owner).notifyRewardAmount(1)).to.be
        .rejected;
    });

    it("notifyRewardAmount - fails if reward amount > balance", async () => {
      await expect(
        stakingRewards.connect(owner).notifyRewardAmount(REWARD_AMOUNTS[0])
      ).to.be.reverted;
    });

    it("notifyRewardAmount - update reward rate when timestamp >= finishAt", async () => {
      await rewardsToken.mint(stakingRewards.target, REWARD_AMOUNTS[0]);
      await stakingRewards.connect(owner).notifyRewardAmount(REWARD_AMOUNTS[0]);

      const block = await ethers.provider.getBlock();

      bigIntEq(
        await stakingRewards.rewardRate(),
        REWARD_AMOUNTS[0] / BigInt(DURATION),
        "rewardRate"
      );
      bigIntEq(
        await stakingRewards.finishAt(),
        block.timestamp + DURATION,
        "finishAt"
      );
      bigIntEq(await stakingRewards.updatedAt(), block.timestamp, "updatedAt");
    });

    it("notifyRewardAmount - update reward rate when timestamp < finishAt", async () => {
      const lastRewardRate = await stakingRewards.rewardRate();
      const lastFinishAt = await stakingRewards.finishAt();

      await rewardsToken.mint(stakingRewards.target, REWARD_AMOUNTS[1]);
      await stakingRewards.connect(owner).notifyRewardAmount(REWARD_AMOUNTS[1]);

      const block = await ethers.provider.getBlock();

      const dt = lastFinishAt - BigInt(block.timestamp);
      const remainingRewards = dt * lastRewardRate;

      bigIntEq(
        await stakingRewards.rewardRate(),
        (remainingRewards + REWARD_AMOUNTS[1]) / BigInt(DURATION),
        "rewardRate"
      );
      bigIntEq(
        await stakingRewards.finishAt(),
        block.timestamp + DURATION,
        "finishAt"
      );
      bigIntEq(await stakingRewards.updatedAt(), block.timestamp, "updatedAt");
    });
  });

  describe("stake", () => {
    it("stake - fails if amount = 0", async () => {
      await expect(stakingRewards.connect(users[0]).stake(0)).to.be.reverted;
    });

    it("stake", async () => {
      await stakingRewards.connect(users[0]).stake(STAKING_AMOUNTS[0]);

      bigIntEq(
        await stakingRewards.totalSupply(),
        STAKING_AMOUNTS[0],
        "totalSupply"
      );
      bigIntEq(
        await stakingRewards.balanceOf(users[0].address),
        STAKING_AMOUNTS[0],
        "balanceOf"
      );
      bigIntEq(
        await stakingToken.balanceOf(stakingRewards.target),
        STAKING_AMOUNTS[0],
        "staking token balance of staking rewards contract"
      );
    });
  });

  describe("withdraw", () => {
    before(async () => {
      await stakingRewards.connect(users[1]).stake(STAKING_AMOUNTS[1]);
    });

    it("withdraw - fails if amount = 0", async () => {
      await expect(stakingRewards.connect(users[1]).withdraw(0)).to.be.reverted;
    });

    it("withdraw", async () => {
      const snapshot = async () => {
        return {
          stakingRewards: {
            totalSupply: await stakingRewards.totalSupply(),
            balanceOfUser: await stakingRewards.balanceOf(users[1].address),
          },
          stakingToken: {
            user: await stakingToken.balanceOf(users[1].address),
          },
        };
      };

      const amount = STAKING_AMOUNTS[1];

      const _before = await snapshot();
      await stakingRewards.connect(users[1]).withdraw(amount);
      const _after = await snapshot();

      bigIntEq(
        _after.stakingRewards.totalSupply,
        _before.stakingRewards.totalSupply - amount,
        "totalSupply"
      );
      bigIntEq(
        _after.stakingRewards.balanceOfUser,
        _before.stakingRewards.balanceOfUser - amount,
        "balanceOf"
      );
      bigIntEq(
        _after.stakingToken.user,
        _before.stakingToken.user + amount,
        "staking token balance of user"
      );
    });
  });

  describe("earned", () => {
    let rewardRate = 0n;
    const totalSupply = STAKING_AMOUNTS[0];
    // earned
    let e0 = 0;
    before(async () => {
      rewardRate = await stakingRewards.rewardRate();
    });

    it("earned - is greater than 0", async () => {
      bigIntEq(
        await stakingRewards.earned(users[2].address),
        0,
        "earned user 3"
      );

      e0 = await stakingRewards.earned(users[0].address);
      expect(e0).to.gte(
        frac((rewardRate * STAKING_AMOUNTS[0]) / totalSupply, 99n, 100n)
      );
    });

    it("earned - increases after 1 week", async () => {
      await skip(DURATION);

      const e1 = await stakingRewards.earned(users[0].address);
      expect(e1).to.gte(e0);
      e0 = e1;
      // earned >= 99% * reward rate * duration * shares / total shares
      expect(e0).to.gte(
        frac(
          (rewardRate * BigInt(DURATION) * STAKING_AMOUNTS[0]) / totalSupply,
          99n,
          100n
        )
      );
    });

    it("earned - does not change after reward duration finishes", async () => {
      // Earned does not increase after finished
      await skip(DURATION);
      const e1 = await stakingRewards.earned(users[0].address);
      bigIntEq(e1, e0, "earned after reward finished");
    });
  });

  describe("getReward", () => {
    it("getReward - reward is greater than 0 for staker", async () => {
      await stakingRewards.connect(users[0]).getReward();

      expect(await rewardsToken.balanceOf(users[0].address)).to.gt(0);
      bigIntEq(await stakingRewards.earned(users[0].address), 0, "earned");
      bigIntEq(await stakingRewards.rewards(users[0].address), 0, "rewards");
    });

    it("getReward - get reward again should return 0", async () => {
      const bal = await rewardsToken.balanceOf(users[0].address);
      await stakingRewards.connect(users[0]).getReward();

      bigIntEq(
        await rewardsToken.balanceOf(users[0].address),
        bal,
        "Rewards of user 0"
      );
      bigIntEq(await stakingRewards.rewards(users[0].address), 0, "rewards");
    });

    it("getReward - no reward for non staker", async () => {
      await stakingRewards.connect(users[2]).getReward();
      bigIntEq(
        await rewardsToken.balanceOf(users[2].address),
        0,
        "reward of non staker"
      );
    });
  });
});

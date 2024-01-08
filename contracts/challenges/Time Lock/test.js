const { ethers } = require("hardhat");
const { expect, getContract, deploy, sendTx } = require("./setup");
const { findLog, ZERO_BYTES_32, warp } = require("./utils");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-073.json`),
  "sol-073.sol",
  "TimeLock"
);

const TEST_TIME_LOCK = getContract(
  require(`../build/TestTimeLock.json`),
  "TestTimeLock.sol",
  "TestTimeLock"
);

const MIN_DELAY = 10;
const MAX_DELAY = 1000;
const GRACE_PERIOD = 1000;

const FUNC = "func()";
const DATA = "0x";

describe("TimeLock", () => {
  let accounts = [];
  let owner;
  let user;
  let timeLock;
  let target;
  // timestamp that was queued
  let timestamp;
  // current timestamp
  let t;

  before(async () => {
    accounts = await ethers.getSigners();
    owner = accounts[0];
    user = accounts[1];
    timeLock = await deploy(json, { account: owner });
    target = await deploy(TEST_TIME_LOCK, {
      account: owner,
      args: [timeLock.target],
    });

    const block = await ethers.provider.getBlock();
    t = block.timestamp;
  });

  describe("queue", () => {
    it("queue - fails if not owner", async () => {
      await expect(
        timeLock.connect(user).queue(target.target, 0, FUNC, DATA, t)
      ).to.be.reverted;
    });

    it("queue - fails if timestamp < block.timesetamp + min delay", async () => {
      await expect(
        timeLock
          .connect(owner)
          .queue(target.target, 0, FUNC, DATA, t + MIN_DELAY - 10)
      ).to.be.reverted;
    });

    it("queue - fails if timestamp > block.timesetamp + max delay", async () => {
      await expect(
        timeLock
          .connect(owner)
          .queue(target.target, 0, FUNC, DATA, t + MAX_DELAY + 10)
      ).to.be.reverted;
    });

    it("queue", async () => {
      timestamp = t + MIN_DELAY + 10;

      const txId = await timeLock.getTxId(
        target.target,
        0,
        FUNC,
        DATA,
        timestamp
      );

      const tx = await sendTx(
        timeLock.connect(owner).queue(target.target, 0, FUNC, DATA, timestamp)
      );

      expect(await timeLock.queued(txId)).to.equal(true);

      const log = findLog(tx, "Queue");
      expect(log?.eventName).to.equal("Queue");
      expect(log?.args?.txId).to.equal(txId);
      expect(log?.args?.target).to.equal(target.target);
      expect(log?.args?.value).to.equal(0);
      expect(log?.args?.func).to.equal(FUNC);
      expect(log?.args?.data).to.equal(DATA);
      expect(log?.args?.timestamp).to.equal(timestamp);
    });

    it("queue - fails if already queued", async () => {
      await expect(
        timeLock.connect(owner).queue(target.target, 0, FUNC, DATA, timestamp)
      ).to.be.reverted;
    });
  });

  describe("execute", () => {
    it("execute - fails if not owner", async () => {
      await expect(
        timeLock.connect(user).execute(target.target, 0, FUNC, DATA, timestamp)
      ).to.be.reverted;
    });

    it("execute - fails if not queued", async () => {
      await expect(
        timeLock.connect(owner).execute(target.target, 0, FUNC, DATA, 0)
      ).to.be.reverted;
    });

    it("execute - fails if block.timestamp < queued timestamp", async () => {
      await expect(
        timeLock.connect(owner).execute(target.target, 0, FUNC, DATA, timestamp)
      ).to.be.reverted;
    });

    it("execute - fails if call to target fails", async () => {
      await warp(timestamp);
      t = timestamp;

      await expect(
        timeLock.connect(owner).execute(target.target, 0, FUNC, DATA, timestamp)
      ).to.be.reverted;
    });

    it("execute", async () => {
      const txId = await timeLock.getTxId(
        target.target,
        0,
        FUNC,
        DATA,
        timestamp
      );

      await target.setCanExecute(true);

      const tx = await sendTx(
        timeLock.connect(owner).execute(target.target, 0, FUNC, DATA, timestamp)
      );

      expect(await timeLock.queued(txId)).to.equal(false);
      expect(await target.executed()).to.equal(true);

      const log = findLog(tx, "Execute");
      expect(log?.eventName).to.equal("Execute");
      expect(log?.args?.txId).to.equal(txId);
      expect(log?.args?.target).to.equal(target.target);
      expect(log?.args?.value).to.equal(0);
      expect(log?.args?.func).to.equal(FUNC);
      expect(log?.args?.data).to.equal(DATA);
      expect(log?.args?.timestamp).to.equal(timestamp);
    });

    it("execute - fails if block.timestamp > grace period", async () => {
      // queue
      t += MIN_DELAY + 10;
      timestamp = t;

      await timeLock
        .connect(owner)
        .queue(target.target, 0, FUNC, DATA, timestamp);

      // fast forward time beyond grace period
      await warp(t + GRACE_PERIOD + 1);
      t += GRACE_PERIOD + 1;

      await expect(
        timeLock.connect(owner).execute(target.target, 0, FUNC, DATA, timestamp)
      ).to.be.reverted;
    });
  });

  describe("cancel", () => {
    it("cancel - fails if not owner", async () => {
      await expect(timeLock.connect(user).cancel(ZERO_BYTES_32)).to.be.reverted;
    });

    it("cancel - fails if not queued", async () => {
      await expect(timeLock.connect(owner).cancel(ZERO_BYTES_32)).to.be
        .reverted;
    });

    it("cancel", async () => {
      // queue
      timestamp = t + MIN_DELAY + 10;

      await timeLock
        .connect(owner)
        .queue(target.target, 0, FUNC, DATA, timestamp);

      const txId = await timeLock.getTxId(
        target.target,
        0,
        FUNC,
        DATA,
        timestamp
      );

      const tx = await sendTx(timeLock.connect(owner).cancel(txId));

      expect(await timeLock.queued(txId)).to.equal(false);

      const log = findLog(tx, "Cancel");
      expect(log?.eventName).to.equal("Cancel");
      expect(log?.args?.txId).to.equal(txId);
    });
  });
});

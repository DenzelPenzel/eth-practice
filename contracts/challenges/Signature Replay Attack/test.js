const { ethers } = require("hardhat");
const { expect, getContract, deploy } = require("./setup");
const { ETHER } = require("./utils");

const SIG_REPLAY = getContract(
  require(`../build/SignatureReplay.json`),
  "SignatureReplay.sol",
  "SignatureReplay"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-068.json`),
  "sol-068.sol",
  "SignatureReplayExploit"
);

describe("SignatureReplayExploit", () => {
  let contract;
  let accounts = [];
  let target;
  before(async () => {
    accounts = await ethers.getSigners();
    target = await deploy(SIG_REPLAY, {
      account: accounts[0],
      value: ETHER * 2n,
    });
    contract = await deploy(json, {
      account: accounts[0],
      args: [target.target],
    });
  });

  it("pwn", async () => {
    const hash = await target.getHash(contract.target, ETHER);
    const sig = await accounts[0].signMessage(ethers.getBytes(hash));

    await contract.pwn(sig);

    const bal = await ethers.provider.getBalance(target.target);
    expect(bal).to.equal(0);
  });
});

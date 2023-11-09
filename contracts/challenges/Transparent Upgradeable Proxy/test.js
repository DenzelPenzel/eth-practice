const { ethers } = require("hardhat");
const {
  expect,
  getContract,
  deploy,
  getContractAt,
  bigIntEq,
} = require("./setup");
const { ZERO_ADDRESS } = require("./utils");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-090.json`),
  "sol-090.sol",
  "TransparentUpgradeableProxy"
);

const V1 = getContract(
  require(`../build/TestTransparentUpgradeableProxy.json`),
  "TestTransparentUpgradeableProxy.sol",
  "CounterV1"
);

const V2 = getContract(
  require(`../build/TestTransparentUpgradeableProxy.json`),
  "TestTransparentUpgradeableProxy.sol",
  "CounterV2"
);

const ADMIN_SLOT =
  "0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103";

const IMP_SLOT =
  "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc";

describe("TransparentUpgradeableProxy", () => {
  let contract;
  let accounts;
  let v1;
  let v2;
  let admin;
  let user;

  before(async () => {
    accounts = await ethers.getSigners();

    contract = await deploy(json, { account: accounts[0] });
    admin = accounts[0];
    user = accounts[2];

    v1 = await deploy(V1, { account: accounts[0] });
    v2 = await deploy(V2, { account: accounts[0] });
  });

  it("constructor - admin is deployer", async () => {
    expect(await contract.connect(admin).admin.staticCall()).to.eq(
      admin.address
    );
  });

  it("changeAdmin - fails if new admin is zero address", async () => {
    await expect(contract.connect(admin).changeAdmin(ZERO_ADDRESS)).to.be
      .reverted;
  });

  it("changeAdmin", async () => {
    await contract.connect(admin).changeAdmin(accounts[1].address);

    admin = accounts[1];
    expect(await contract.connect(admin).admin.staticCall()).to.eq(
      admin.address
    );
  });

  it("upgradeTo - fails if code size of implementation = 0", async () => {
    await expect(contract.connect(admin).upgradeTo(ZERO_ADDRESS)).to.be
      .reverted;
  });

  it("upgradeTo", async () => {
    await contract.connect(admin).upgradeTo(v1.target);

    expect(await contract.connect(admin).implementation.staticCall()).to.eq(
      v1.target
    );
  });

  it("admin", async () => {
    const data = await ethers.provider.getStorage(contract.target, ADMIN_SLOT);
    expect(`0x${data.slice(26)}`).to.equal(admin.address.toLowerCase());
  });

  it("implementation", async () => {
    const data = await ethers.provider.getStorage(contract.target, IMP_SLOT);
    expect(`0x${data.slice(26)}`).to.equal(v1.target.toLowerCase());
  });

  it("fallback", async () => {
    const proxy = getContractAt(V1, contract.target);
    await proxy.connect(user).inc();
    bigIntEq(await proxy.count(), 1n, "count");
  });

  it("upgrade", async () => {
    await contract.connect(admin).upgradeTo(v2.target);

    const proxy = getContractAt(V2, contract.target);

    await proxy.connect(user).inc();
    bigIntEq(await proxy.count(), 2n, "count");

    await proxy.connect(user).dec();
    bigIntEq(await proxy.count(), 1n, "count");
  });

  it("ifAdmin modifier - changeAdmin", async () => {
    await expect(contract.connect(admin).changeAdmin(admin.address)).not.to.be
      .reverted;
    await expect(contract.connect(user).changeAdmin(admin.address)).to.be
      .reverted;
  });

  it("ifAdmin modifier - upgradeTo", async () => {
    await expect(contract.connect(admin).upgradeTo(v1.target)).not.to.be
      .reverted;
    await expect(contract.connect(user).upgradeTo(v1.target)).to.be.reverted;
  });

  it("ifAdmin modifier - admin", async () => {
    await expect(contract.connect(admin).admin()).not.to.be.reverted;
    await expect(contract.connect(user).admin()).to.be.reverted;
  });

  it("ifAdmin modifier - implementation", async () => {
    await expect(contract.connect(admin).implementation()).not.to.be.reverted;
    await expect(contract.connect(user).implementation()).to.be.reverted;
  });
});

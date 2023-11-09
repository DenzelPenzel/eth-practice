const { ethers } = require("hardhat");
const { expect, getContract, deploy, sendTx, bigIntEq } = require("./setup");
const { findLog, ZERO_ADDRESS } = require("./utils");

const ERC1155_TOKEN_RECEIVER_JSON = getContract(
  require(`../build/ERC1155TokenReceiver.json`),
  "ERC1155TokenReceiver.sol",
  "ERC1155TokenReceiver"
);

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-092.json`),
  "sol-092.sol",
  "MyMultiToken"
);

describe("ERC1155", () => {
  let multiToken;
  let accounts = [];
  let receiver;
  before(async () => {
    accounts = await ethers.getSigners();
    multiToken = await deploy(json, { account: accounts[0] });
    receiver = await deploy(ERC1155_TOKEN_RECEIVER_JSON, {
      account: accounts[0],
    });
  });

  it("mint", async () => {
    const tx = await sendTx(multiToken.mint(1, 100, "0x"));

    const log = findLog(tx, "TransferSingle");
    expect(log?.eventName).to.equal("TransferSingle");
    expect(log?.args?.operator).to.equal(accounts[0].address);
    expect(log?.args?.from).to.equal(ZERO_ADDRESS);
    expect(log?.args?.to).to.equal(accounts[0].address);
    bigIntEq(log?.args?.id, 1, "TransferSingle token id");
    bigIntEq(log?.args?.value, 100, "TransferSingle value");

    bigIntEq(
      await multiToken.balanceOf(accounts[0].address, 0),
      0,
      "balance 0"
    );
    bigIntEq(
      await multiToken.balanceOf(accounts[0].address, 1),
      100,
      "balance 1"
    );
  });

  it("batchMint", async () => {
    const ids = [11, 22];
    const values = [111n, 222n];
    const data = "0x";

    const tx = await sendTx(multiToken.batchMint(ids, values, data));

    const log = findLog(tx, "TransferBatch");
    expect(log?.eventName).to.equal("TransferBatch");
    expect(log?.args?.operator).to.equal(accounts[0].address);
    expect(log?.args?.from).to.equal(ZERO_ADDRESS);
    expect(log?.args?.to).to.equal(accounts[0].address);

    for (let i = 0; i < log?.args?.ids?.length; i++) {
      const id = log?.args?.ids[i];
      bigIntEq(id, ids[i], "TransferBatch token id");
    }

    for (let i = 0; i < log?.args?.values?.length; i++) {
      const value = log?.args?.values[i];
      bigIntEq(value, values[i], "TransferBatch value");
    }

    for (let i = 0; i < ids.length; i++) {
      bigIntEq(
        await multiToken.balanceOf(accounts[0].address, ids[i]),
        values[i],
        `balance ${i}`
      );
    }
  });

  it("burn", async () => {
    const tx = await sendTx(multiToken.burn(1, 100));

    const log = findLog(tx, "TransferSingle");
    expect(log?.eventName).to.equal("TransferSingle");
    expect(log?.args?.operator).to.equal(accounts[0].address);
    expect(log?.args?.from).to.equal(accounts[0].address);
    expect(log?.args?.to).to.equal(ZERO_ADDRESS);
    bigIntEq(log?.args?.id, 1, "TransferSingle token id");
    bigIntEq(log?.args?.value, 100, "TransferSingle value");

    bigIntEq(
      await multiToken.balanceOf(accounts[0].address, 1),
      0,
      "balance 1"
    );
  });

  it("batchBurn", async () => {
    const ids = [11, 22];
    const values = [111n, 222n];

    const tx = await sendTx(multiToken.batchBurn(ids, values));

    const log = findLog(tx, "TransferBatch");
    expect(log?.eventName).to.equal("TransferBatch");
    expect(log?.args?.operator).to.equal(accounts[0].address);
    expect(log?.args?.from).to.equal(accounts[0].address);
    expect(log?.args?.to).to.equal(ZERO_ADDRESS);

    for (let i = 0; i < log?.args?.ids?.length; i++) {
      const id = log?.args?.ids[i];
      bigIntEq(id, ids[i], "TransferBatch token id");
    }

    for (let i = 0; i < log?.args?.values?.length; i++) {
      const value = log?.args?.values[i];
      bigIntEq(value, values[i], "TransferBatch value");
    }

    for (let i = 0; i < ids.length; i++) {
      bigIntEq(
        await multiToken.balanceOf(accounts[0].address, ids[i]),
        0,
        `balance ${i}`
      );
    }
  });

  it("balanceOfBatch - fails if owners.length and ids.length are not equal", async () => {
    await expect(multiToken.balanceOfBatch([], [1])).to.be.reverted;
  });

  it("balanceOfBatch", async () => {
    const bals = [
      {
        account: accounts[0],
        ids: [1, 2],
        values: [100n, 200n],
      },
      {
        account: accounts[1],
        ids: [2, 3],
        values: [200n, 300n],
      },
    ];

    for (let i = 0; i < bals.length; i++) {
      const { account, ids, values } = bals[i];
      await multiToken.connect(account).batchMint(ids, values, "0x");
    }

    {
      const res = await multiToken.balanceOfBatch(
        [accounts[0].address, accounts[0].address],
        [1, 2]
      );

      bigIntEq(res[0], 100n, "batch balance of account 0");
      bigIntEq(res[1], 200n, "batch balance of account 0");
    }

    {
      const res = await multiToken.balanceOfBatch(
        [accounts[1].address, accounts[1].address],
        [2, 3]
      );

      bigIntEq(res[0], 200n, "batch balance of account 1");
      bigIntEq(res[1], 300n, "batch balance of account 1");
    }

    {
      const res = await multiToken.balanceOfBatch(
        [accounts[0].address, accounts[1].address],
        [1, 3]
      );

      bigIntEq(res[0], 100n, "batch balance of account 0");
      bigIntEq(res[1], 300n, "batch balance of account 1");
    }
  });

  it("setApprovalForAll", async () => {
    // accounts[0] approves accounts[2]
    const tx = await sendTx(
      multiToken.setApprovalForAll(accounts[2].address, true)
    );

    const log = findLog(tx, "ApprovalForAll");
    expect(log?.eventName).to.equal("ApprovalForAll");
    expect(log?.args?.owner).to.equal(accounts[0].address);
    expect(log?.args?.operator).to.equal(accounts[2].address);
    expect(log?.args?.approved).to.equal(true);

    expect(
      await multiToken.isApprovedForAll(
        accounts[0].address,
        accounts[2].address
      )
    ).to.equal(true);
  });

  it("safeTransferFrom - not approved", async () => {
    const from = accounts[0].address;
    const to = accounts[1].address;
    const operator = accounts[1];
    const id = 1;
    const value = 10n;

    await expect(
      multiToken.connect(operator).safeTransferFrom(from, to, id, value, "0x")
    ).to.be.reverted;
  });

  it("safeTransferFrom - send to 0 address fails", async () => {
    const from = accounts[0].address;
    const to = ZERO_ADDRESS;
    const id = 1;
    const value = 10n;

    await expect(multiToken.safeTransferFrom(from, to, id, value, "0x")).to.be
      .reverted;
  });

  it("safeTransferFrom - from owner", async () => {
    const from = accounts[0].address;
    const to = accounts[1].address;
    const id = 1;
    const value = 10n;

    const snapshot = async () => {
      return {
        from: await multiToken.balanceOf(from, id),
        to: await multiToken.balanceOf(to, id),
      };
    };

    const s0 = await snapshot();
    const tx = await sendTx(
      multiToken.safeTransferFrom(from, to, id, value, "0x")
    );
    const s1 = await snapshot();

    const log = findLog(tx, "TransferSingle");
    expect(log?.eventName).to.equal("TransferSingle");
    expect(log?.args?.operator).to.equal(from);
    expect(log?.args?.from).to.equal(from);
    expect(log?.args?.to).to.equal(to);
    expect(log?.args?.id).to.equal(id);
    expect(log?.args?.value).to.equal(value);

    bigIntEq(s1.from, s0.from - value, "balance of account 0");
    bigIntEq(s1.to, s0.to + value, "balance of account 1");
  });

  it("safeTransferFrom - from operator", async () => {
    const from = accounts[0].address;
    const to = accounts[1].address;
    const operator = accounts[2];
    const id = 1;
    const value = 10n;

    const snapshot = async () => {
      return {
        from: await multiToken.balanceOf(from, id),
        to: await multiToken.balanceOf(to, id),
      };
    };

    const s0 = await snapshot();
    await multiToken
      .connect(operator)
      .safeTransferFrom(from, to, id, value, "0x");
    const s1 = await snapshot();

    bigIntEq(s1.from, s0.from - value, "balance of account 0");
    bigIntEq(s1.to, s0.to + value, "balance of account 1");
  });

  it("safeTransferFrom - fails if receiver returns incorrect selector", async () => {
    await receiver.setFail(true);

    const from = accounts[0].address;
    const to = receiver.target;
    const operator = accounts[2];
    const id = 1;
    const value = 10n;
    const data = "0x1212";

    await expect(
      multiToken.connect(operator).safeTransferFrom(from, to, id, value, data)
    ).to.be.reverted;
  });

  it("safeTransferFrom - to contract", async () => {
    await receiver.setFail(false);

    const from = accounts[0].address;
    const to = receiver.target;
    const operator = accounts[2];
    const id = 1;
    const value = 10n;
    const data = "0x1212";

    const snapshot = async () => {
      return {
        from: await multiToken.balanceOf(from, id),
        to: await multiToken.balanceOf(to, id),
      };
    };

    const s0 = await snapshot();
    await multiToken
      .connect(operator)
      .safeTransferFrom(from, to, id, value, data);
    const s1 = await snapshot();

    bigIntEq(s1.from, s0.from - value, "balance of account 0");
    bigIntEq(s1.to, s0.to + value, "balance of receiver");

    expect(await receiver.operator()).to.equal(operator.address);
    expect(await receiver.from()).to.equal(from);
    expect(await receiver.id()).to.equal(id);
    expect(await receiver.value()).to.equal(value);
    expect(await receiver.data()).to.equal(data);
  });

  it("safeBatchTransferFrom - send to 0 address fails", async () => {
    const from = accounts[0].address;
    const to = ZERO_ADDRESS;
    const ids = [1, 2];
    const values = [10n, 20n];

    await expect(multiToken.safeBatchTransferFrom(from, to, ids, values, "0x"))
      .to.be.reverted;
  });

  it("safeBatchTransferFrom - not approved", async () => {
    const from = accounts[0].address;
    const to = accounts[1].address;
    const operator = accounts[1];
    const ids = [1, 2];
    const values = [10n, 20n];

    await expect(
      multiToken
        .connect(operator)
        .safeBatchTransferFrom(from, to, ids, values, "0x")
    ).to.be.reverted;
  });

  it("safeBatchTransferFrom - fails if ids length != values length", async () => {
    const from = accounts[0].address;
    const to = accounts[1].address;
    const ids = [1, 2];
    const values = [10n];

    await expect(multiToken.safeBatchTransferFrom(from, to, ids, values, "0x"))
      .to.be.reverted;
  });

  it("safeBatchTransferFrom - fails if receiver returns incorrect selector", async () => {
    await receiver.setFail(true);

    const from = accounts[0].address;
    const to = receiver.target;
    const operator = accounts[2];
    const ids = [1, 2];
    const values = [10n, 20n];
    const data = "0x1212";

    await expect(
      multiToken
        .connect(operator)
        .safeBatchTransferFrom(from, to, ids, values, data)
    ).to.be.reverted;
  });

  it("safeBatchTransferFrom - to contract", async () => {
    await receiver.setFail(false);

    const from = accounts[0].address;
    const to = receiver.target;
    const operator = accounts[2];
    const ids = [1, 2];
    const values = [10n, 20n];
    const data = "0x1212";

    const snapshot = async () => {
      return {
        from: await Promise.all(
          ids.map((id) => multiToken.balanceOf(from, id))
        ),
        to: await Promise.all(ids.map((id) => multiToken.balanceOf(to, id))),
      };
    };

    const s0 = await snapshot();
    await multiToken
      .connect(operator)
      .safeBatchTransferFrom(from, to, ids, values, data);
    const s1 = await snapshot();

    for (let i = 0; i < ids.length; i++) {
      const value = values[i];
      bigIntEq(s1.from[i], s0.from[i] - value, "balance of account 0");
      bigIntEq(s1.to[i], s0.to[i] + value, "balance of receiver");
    }

    expect(await receiver.operator()).to.equal(operator.address);
    expect(await receiver.from()).to.equal(from);
    for (let i = 0; i < ids.length; i++) {
      expect(await receiver.ids(i)).to.equal(ids[i]);
      expect(await receiver.values(i)).to.equal(values[i]);
    }
    expect(await receiver.data()).to.equal(data);
  });
});

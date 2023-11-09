const { ethers } = require("hardhat");
const { expect, getContract, deploy, bigIntEq } = require("./setup");
const { MAX_UINT } = require("./utils");

const json = getContract(
  require(`${process.env.USER_BUILD_DIR}/sol-091.json`),
  "sol-091.sol",
  "GaslessTokenTransfer"
);

const ERC20_PERMIT = getContract(
  require(`../build/ERC20Permit.json`),
  "ERC20Permit.sol",
  "ERC20Permit"
);

async function getPermitSignature(signer, token, spender, value, deadline) {
  const network = await signer.provider.getNetwork();
  const [nonce, name, version, chainId] = await Promise.all([
    token.nonces(signer.address),
    token.name(),
    "1",
    network.chainId,
  ]);

  return ethers.Signature.from(
    await signer.signTypedData(
      {
        name,
        version,
        chainId,
        verifyingContract: token.target,
      },
      {
        Permit: [
          {
            name: "owner",
            type: "address",
          },
          {
            name: "spender",
            type: "address",
          },
          {
            name: "value",
            type: "uint256",
          },
          {
            name: "nonce",
            type: "uint256",
          },
          {
            name: "deadline",
            type: "uint256",
          },
        ],
      },
      {
        owner: signer.address,
        spender,
        value,
        nonce,
        deadline,
      }
    )
  );
}

describe("GaslessTokenTransfer", () => {
  let contract;
  let accounts;
  let sender;
  let receiver;
  let relayer;
  let erc20;

  const AMOUNT = 100n;
  const FEE = 1n;

  before(async () => {
    accounts = await ethers.getSigners();
    sender = accounts[0];
    receiver = accounts[1];
    relayer = accounts[2];

    contract = await deploy(json, { account: accounts[0] });

    erc20 = await deploy(ERC20_PERMIT, {
      account: accounts[0],
      args: ["test", "TEST", 18],
    });
    await erc20.mint(sender.address, AMOUNT + FEE);
  });

  it("send - invalid signature", async () => {
    const deadline = MAX_UINT;
    const sig = await getPermitSignature(
      sender,
      erc20,
      contract.target,
      AMOUNT + FEE,
      deadline
    );

    await expect(
      contract.connect(relayer).send(
        erc20.target,
        sender.address,
        receiver.address,
        AMOUNT,
        // Increase fee to make signature invalid
        FEE + 1n,
        deadline,
        sig.v,
        sig.r,
        sig.s
      )
    ).to.be.reverted;
  });

  it("send", async () => {
    const deadline = MAX_UINT;
    const sig = await getPermitSignature(
      sender,
      erc20,
      contract.target,
      AMOUNT + FEE,
      deadline
    );

    await contract
      .connect(relayer)
      .send(
        erc20.target,
        sender.address,
        receiver.address,
        AMOUNT,
        FEE,
        deadline,
        sig.v,
        sig.r,
        sig.s
      );

    bigIntEq(await erc20.balanceOf(sender.address), 0n, "sender balance");
    bigIntEq(
      await erc20.balanceOf(receiver.address),
      AMOUNT,
      "receiver balance"
    );
    bigIntEq(await erc20.balanceOf(relayer.address), FEE, "relayer balance");
  });
});

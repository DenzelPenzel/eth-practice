import { ethers } from "ethers";
import Counter from "../artifacts/contracts/Counter.sol/Counter.json";

function getEth() {
  // @ts-ignore
  const eth = window.ethereum;
  if (!eth) {
    throw new Error("get metamask and a positive attitude");
  }
  return eth;
}

async function hasAccounts() {
  const eth = getEth();
  const accounts = (await eth.request({ method: "eth_accounts" })) as string[];
  return accounts && accounts.length;
}

async function requestAccounts() {
  const eth = getEth();
  const accounts = (await eth.request({
    method: "eth_requestAccounts",
  })) as string[];

  return accounts && accounts.length;
}

async function run() {
  if (!(await hasAccounts()) && !(await requestAccounts())) {
    throw new Error("Please let me take your money");
  }

  const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS || "";

  const counter = new ethers.Contract(
    CONTRACT_ADDRESS,
    Counter.abi,
    new ethers.providers.Web3Provider(getEth()).getSigner() // provider
  );

  const el = document.createElement("div");
  async function setCounter(count?: number) {
    el.innerHTML = count || (await counter.getCounter());
  }
  setCounter();

  const button = document.createElement("button");
  button.innerText = "increment";
  button.onclick = async function () {
    await counter.count();
    // const tx = ;
    // await tx.wait();
    // setCounter();
  };

  counter.on(counter.filters.CounterInc(), (cnt) => {
    setCounter(cnt);
  });

  document.body.appendChild(el);
  document.body.appendChild(button);
}

run();

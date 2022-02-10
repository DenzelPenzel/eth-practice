import { Contract } from "ethers";
import { ethers } from "hardhat";

async function deploy(name: string, ...args: any[]) {
  console.log("===", name);
  const Example = await ethers.getContractFactory(name);
  const example = await Example.deploy(...args);
  await example.deployed();

  console.log(`deploy ${name} ${example.address}`);

  return example;
}

async function getStorageAddress(
  contract: Contract,
  name: string,
  count: number
) {
  for (let i = 0; i < count; i++) {
    // get storage of the index "i" using address "contract.address"
    const x = await ethers.provider.getStorageAt(contract.address, i);
    console.log(`${name} ${i} ${x}`);
  }
}

async function main() {
  const a = await deploy("A");
  const b = await deploy("B", a.address);

  console.log("===");

  await getStorageAddress(b, "B", 3); // print first 3 items inside b
  await b.setB(0x45);

  console.log("===");
  await getStorageAddress(b, "B", 3);

  /*
  console.log("A", await a.getA());
  console.log("B", await b.getB());
  console.log("---------");

  await a.setA(42);
  console.log("A", await a.getA());
  console.log("B", await b.getB());
  console.log("---------");

  await b.setB(60);
  console.log("A", await a.getA());
  console.log("B", await b.getB());
  console.log("---------");
  */
}

main().catch((error) => {
  console.error(error);
  process.exitCode = -1;
});

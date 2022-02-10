// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function counterDeploy() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  const Counter = await ethers.getContractFactory("Counter");
  const counter = await Counter.deploy();
  await counter.deployed();
  return counter;
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
counterDeploy()
  .then(async (counter) => {
    await counter.count();
    const res = await counter.getCounter();

    console.log("Counter deployed to:", counter.address);
    console.log("Counter output", res);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = -1;
  });

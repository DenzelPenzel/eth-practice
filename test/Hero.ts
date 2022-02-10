import "@nomiclabs/hardhat-ethers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Hero", function () {
  async function deployContract() {
    const Hero = await ethers.getContractFactory("TestHero");
    const hero = await Hero.deploy();
    await hero.deployed();
    return hero;
  }
  let hero: any;

  before(async () => {
    hero = await deployContract();
  });

  it("should get a zero hero array", async () => {
    expect((await hero.getHeroes()).length).to.equal(0);
  });

  it("should fail at creating hero cause of payment", async () => {
    try {
      await hero.createHero(0, {
        value: ethers.utils.parseEther("0.0499999"),
      });
    } catch (error) {
      if (error instanceof Error) {
        expect(error.message.includes("Please send more money")).to.equal(true);
      }
    }
  });

  it("should fail at creating hero cause of payment", async () => {
    const hero = await deployContract();
    await hero.setRandom(69);
    await hero.createHero(0, {
      value: ethers.utils.parseEther("0.05"),
    });
    const h = (await hero.getHeroes())[0];
    expect(await hero.getMagic(h)).to.equal(16);
    expect(await hero.getHealth(h)).to.equal(2);
  });
});

// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "hardhat/console.sol";

/*
- Generate random Hereos
- The user gets to put in their class of hereo on generation
- Paid 0.05 eth per hero 
- Get all my heroes I have generated
- Heroes should be stored on the chain 
- Stats are intellect, strength, dexterity, magic, health 
- Stats are randomly generated 
    - A scale of 1 - 18
    - Stat 1 can max at 18
    - Stat 2 can max at 17
    - Stat 3 can max at 16
- Imagine these being an NFT
- Not divisable
Classes:  
    - Mage
    - Healer
    - Barbarian

Class will not influence stats created, therefore getting an epic hero will be hard
*/

contract Hero {
    enum Class {
        Mage,
        Healer,
        Barbarian
    } // saving program, if ordering should be not the same 1, 2, 3

    mapping(address => uint256[]) addressToHeroes;

    function generateRandom() public virtual view returns (uint256) {
        // 256 bytes random number
        // block.difficulty- provided by mining pool
        return
            uint256(
                keccak256(abi.encodePacked(block.difficulty, block.timestamp))
            );
    }

    function getHeroes() public view returns (uint256[] memory) {
        return addressToHeroes[msg.sender];
    }

    function getStrength(uint hero) public pure returns (uint32) {
        // the hole dataset = 256 bits
        // [5 bits stat][5 bits stat][5 bits stat]|[5 bits stat][2 bits class name]
        // shift it and then select the first rightmost 5 bits using 11111 mask
        // 0x1F = 11111
        // 109 = 1101101
        // 109 >> 2 = 27 = 11011 & 11111 = 11011
        return uint32((hero >> 2) & 0x1F);
    }

    function getHealth(uint256 hero) public pure returns (uint32) {
        return uint32((hero >> 7) & 0x1F);
    }

    function getDex(uint256 hero) public pure returns (uint32) {
        return uint32((hero >> 12) & 0x1F);
    }

    function getIntellect(uint256 hero) public pure returns (uint32) {
        return uint32((hero >> 17) & 0x1F);
    }

    function getMagic(uint256 hero) public pure returns (uint32) {
        return uint32((hero >> 22) & 0x1F);
    }

    // payable - can except money into it
    function createHero(Class heroType) public payable {
        require(msg.value >= 0.05 ether, "Please send more money");
        
        // array stored in the function, memory represent the stack mem
        uint256[] memory stats = new uint256[](5);
        stats[0] = 2;
        stats[1] = 7;
        stats[2] = 12;
        stats[3] = 17;
        stats[4] = 22;

        uint256 hero = uint256(heroType);
        uint256 len = 5;

        do {
            uint256 pos = generateRandom() % len;
            uint256 value = (generateRandom() % (13 + len)) + 1;

            hero |= value << stats[pos];

            len--;
            stats[pos] = stats[len];
        } while (len > 0);
        //
        addressToHeroes[msg.sender].push(hero);
    }
}

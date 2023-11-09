// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "hardhat/console.sol";

contract Token {
    mapping(address => uint) public balances;

    constructor() {
        balances[msg.sender] = 100;
    }

    function transfer(address to, uint amount) external {
        balances[msg.sender] -= amount;
        balances[to] += amount;

        console.log("transfer", msg.sender, to, amount);
    }
}
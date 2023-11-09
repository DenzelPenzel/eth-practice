/*
All solidity challenges in smartcontract.engineer can be debugged with Hardhat's console.sol.

You can print logging messages and contract variables by calling console.log.

Run the tests and messages will be printed along with the output of the tests.

For more info about hardhat, check out the documentation

Task:
    - Import hardhat/console.sol
        import "hardhat/console.sol";


    - Inside the function transfer, call console.log to print variables.
        The output of console.log will be printed on the terminal when you run the test.

        console.log("transfer", msg.sender, to, amount);
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Token {
    mapping(address => uint) public balances;

    constructor() {
        balances[msg.sender] = 100;
    }

    function transfer(address to, uint amount) external {
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}

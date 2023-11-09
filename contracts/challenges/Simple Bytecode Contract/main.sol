/*
Write a smart contract that always return the number 42. The size of the smart contract must be less than or equal to 10 bytes.

Tasks:
    - Write the runtime code that will always return 42.
        Store it as a comment for now.

    - Write the creation code for the runtime code from task 1.
        Store it as a comment for now.

    - Complete the function deploy
        function deploy() external {}
            - Deploy the bytecode from task 2
            - emit the event Log with the address of the deployed contract

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Factory {
    event Log(address addr);

    function deploy() external {
        // Code
    }
}

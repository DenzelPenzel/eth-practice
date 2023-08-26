/*
Variables declared immutable are like constants, except their value can be set inside the constructor.

Tasks:
- Modify state variable owner to be immutable

- Set owner to msg.sender inside the constructor.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Immutable {
    // Write your code here
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }
}


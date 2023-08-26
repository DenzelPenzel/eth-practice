/*
Functions and addresses declared as payable can receive Ether.

Tasks:
    - Make function deposit able to accept Ether by declaring it payable.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Payable {
    // Payable address can receive Ether
    address payable public owner;

    // Payable constructor can receive Ether
    constructor() payable {
        owner = payable(msg.sender);
    }

    function deposit() external payable {}
}

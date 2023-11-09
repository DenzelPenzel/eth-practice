/*
Hodl is a contract where users can deposit ETH but can only withdraw after a certain time has elapsed.

Tasks:

Implement:
    function deposit() external payable {}

    User can deposit ETH by calling this function.

    This function will update user's balance, total ETH deposited by msg.sender.
    Update lockedUntil for msg.sender to current timestamp plus HODL_DURATION


Implement:
    function withdraw() external {}

    User cannot withdraw if HODL_DURATION has not elapsed since the last deposit of the user.
    It sends back all balance of msg.sender

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Hodl {
    uint private constant HODL_DURATION = 3 * 365 days;

    mapping(address => uint) public balanceOf;
    mapping(address => uint) public lockedUntil;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
        lockedUntil[msg.sender] = block.timestamp + HODL_DURATION;
    }

    function withdraw() external {
        require(block.timestamp >= lockedUntil[msg.sender], "locked");
        uint bal = balanceOf[msg.sender];
        balanceOf[msg.sender] = 0;
        payable(msg.sender).transfer(bal);
    }
}

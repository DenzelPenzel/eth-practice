// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Account {
    address public bank;
    address public owner;
    uint public withdrawLimit;

    constructor(address _owner, uint _withdrawLimit) payable {
        bank = msg.sender;
        owner = _owner;
        withdrawLimit = _withdrawLimit;
    }
}

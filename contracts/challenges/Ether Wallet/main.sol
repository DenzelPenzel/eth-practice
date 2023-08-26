/*
Create a contract that can receive Ether from anyone. Only the owner can withdraw.

Tasks:
    - Enable the contract to receive Ether.

    - Implement function withdraw(uint _amount) external
      This function will send _amount of Ether to owner. Only the owner can call this function.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function withdraw(uint _amout) external {
        require(msg.sender == owner, "not owner");
        (bool sent, ) = owner.call{value: _amout}("");
        require(sent, "Failed to send Ether");
    }

    receive() external payable {}
}

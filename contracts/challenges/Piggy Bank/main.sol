/*
Implement a piggy bank.

Anyone can send Ether to this contract. 
However only the owner can withdraw, upon which the contract will be deleted.

Tasks:
    - Set owner to msg.sender when this contract is deployed.
    - Enable this contract to receive Ether, 
      emit the event Deposit with the amount of Ether that was received.
    - Write external function withdraw().
        - Emit the Withdraw event with the current balance of Ether stored in the contract
        - Send all of Ether to owner
        - Delete the contract from the blockchain
        - Only owner can call this function
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PiggyBank {
    event Deposit(uint amount);
    event Withdraw(uint amount);
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        emit Deposit(msg.value);
    }

    function withdraw() external {
        require(msg.sender == owner, "not owner");
        emit Withdraw(address(this).balance); // get current ballance to withdraw
        selfdestruct(payable(owner));
    }
}

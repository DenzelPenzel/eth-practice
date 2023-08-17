/*
Create a contract that has an owner and only the owner can assign a new owner.


Tasks:
- When this contract is created, initiallize owner to msg.sender.

- Create a function modifier onlyOwner that will restrict function calls to the current owner.
  It should checks that the caller is the current owner before executing the rest of the code,
  otherwise throw an error with the message "not owner".

- Create an external function setOwner(address _newOwner) which will set ownerto_newOwner.
  This function can only be called by the current owner.
  Check that _newOwner is not address(0) and throw an error "new owner = zero address" if it is.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    modifier onlyOwner() {
        require(isOwner(), "not owner");
        _;
    }

    function setOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "new owner = zero address");
        owner = _newOwner;
    }
}

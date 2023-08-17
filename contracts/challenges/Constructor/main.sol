/*
constructor is a special function that is called only once when the contract is deployed.

The main purpose of the the constructor is to set state variables to some initial state.

Task: 
- Modify the constructor. It should take in an input of type uint and set the state variable x.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ConstructorIntro {
    address public owner;
    uint public x;

    constructor(uint _x) {
        // Here the owner is set to the caller
        owner = msg.sender;
        x = _x;
    }
}

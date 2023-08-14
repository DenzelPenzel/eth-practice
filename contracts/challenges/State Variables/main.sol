/*
There are 3 types of variables in Solidity, local, state and global.

Let's start off with state variables.

State variables are stored on the blockchain. So you can save some data into a state variable, come back a week later and the data will still be there.

How do you declare a state variable?
State variables are declared inside contract, outside functions. Here is an example

contract MyContract {
    // this is a state variable
    uint public myStateVariable;

    function func() external {
        // this is not a state variable
        uint notStateVariable = 123;
    }
}
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StateVariables {
    uint public num;

    function setNum(uint _num) external {
        num = _num;
    }

    // What is "view"?
    // "view" tells Solidity that this is a read-only function.
    // It does not make any updates to the blockchain.
    function getNum() external view returns (uint) {
        return num;
    }
    
    
    function resetNum() external {
        num = 0;
    }
    
    function getNumPlusOne() external view returns (uint) {
        return num + 1;
    }
}

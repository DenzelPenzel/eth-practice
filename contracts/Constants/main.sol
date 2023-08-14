/*
State variables can be declared as constant. 

Value of constant variables must be set before compilation 
and it cannot be modified after the contract is compiled.

Why use constants?
Compared to state variables, constant variables use less gas.

Style guide
Following convention, constants should be named with all capital letters with underscore separating words.

THIS_IS_MY_CONSTANT_VAR

Task: 
- Create a constant variable named MY_UINT. This variable is public, uint type, value set to 123.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Constants {
    address public constant MY_ADDR =
        0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
    
    uint public MY_UINT = 123;
    
}

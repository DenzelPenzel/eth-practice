/*
Complete the Counter contract.

This contract must

store an uint state variable named count.

have functions to increment and decrement count.

How do I get the value of count?
You won't need to implement a getter function for count. 
Solidity automatically creates an external view function for the state variable count.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {
    // Write your code here
    uint public count;
    
    function inc() external {
        count += 1;
    }
    
    function dec() external {
        count -= 1;
    }
    
}

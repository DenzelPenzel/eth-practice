/*
Here is an example of a function.

function add(uint x, uint y) external pure returns (uint) {
    return x + y;
}

This function returns the sum of two numbers x and y.

What are external and pure?
    - external tells Solidity that this function can only be called from outside this contract.

    - pure tells Solidity that this function does not write anything to the blockchain.

Don't worry if that didn't make sense.

external will be fully explained in the section about function visibility.

Check out the section about view and pure functions for explanation about pure.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FunctionIntro {
    function add(uint x, uint y) external pure returns (uint) {
        return x + y;
    }

    function sub(uint x, uint y) external pure returns (uint) {
        return x - y;
    }
}


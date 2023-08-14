/*
Unlike state variables, local variables are not stored on the blockchain.

How do you declare a local variable?
Local variables are declared inside functions.

Any data assigned to a local variable will be lost after the function finishes execution.

Here is an example

contract MyContract {
    function func() external {
        uint localVar = 123;
        // localVar is not saved to blockchain.
    }
}
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LocalVariables {
    function localVars() external {
        uint u = 123;
        bool b = true;
    }
    
    function mul() external pure returns(uint) {
        uint x = 123456;
        return x * x;
    }
}

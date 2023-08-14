/*
Functions that do not write anything to blockchain can be declared as view or pure.

What's the difference between view and pure?
view functions can read state and global variables.

pure functions cannot read neither state nor global variables.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ViewAndPureFunctions {
    uint public num;

    // This is a view function. It reads the state variable "num"
    function viewFunc() external view returns (uint) {
        return num;
    }

    // This is a pure function. It does not read any state or global variables.
    function pureFunc() external pure returns (uint) {
        return 1;
    }
    
    function addToNum(uint x) external view returns (uint) {
        return x + num;
    }
    
    function add(uint x, uint y) external pure returns (uint) {
        return x + y;
    }
}

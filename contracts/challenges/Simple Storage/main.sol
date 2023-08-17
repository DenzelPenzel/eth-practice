/*
Complete SimpleStorage, a contract that stores a single state variable named text of type string.

Tasks:
- Declare a public state variable named text of type string.

- Write external function set, takes in a single input _text of type string,  
  updates the text state variable to the input _text.

- Write external function get() which will return the current value of text.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleStorage {
    // Write your code here
    
    string public text;
    
    function set(string calldata _text) external {
        text = _text;
    }
    
    function get() external view returns (string memory) {
        return text;
    }
}

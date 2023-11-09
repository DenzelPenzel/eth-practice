/*
Solidity allows you to define custom errors.


Tasks:
    - Define 2 custom errors
        error InvalidAddress();
        error NotAuthorized(address caller);

    - Complete the function
        function setOwner(address _owner) external {}

        This function sets the owner state variable to the input _owner.
            - Check that _owner is not the zero address, revert with InvalidAddress
            - Revert with NotAuthorize(msg.sender) if msg.sender is not the current owner.
            - If the 2 checks above pass, set the new owner.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CustomError {
    error MyError(address caller, uint i);

    address public owner = msg.sender;

    function testMyError(uint i) external {
        if (i < 10) {
            revert MyError(msg.sender, i);
        }
    }

    function setOwner(address _owner) external {
        // Write your code here
    }
}

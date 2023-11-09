// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CustomError {
    error MyError(address caller, uint i);

    error InvalidAddress();
    error NotAuthorized(address caller);

    address public owner = msg.sender;

    function testMyError(uint i) external {
        if (i < 10) {
            revert MyError(msg.sender, i);
        }
    }

    function setOwner(address _owner) external {
        if (_owner == address(0)) {
            revert InvalidAddress();
        }
        if (msg.sender != owner) {
            revert NotAuthorized(msg.sender);
        }
        owner = _owner;
    }
}

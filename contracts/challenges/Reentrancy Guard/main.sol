/*

Implement a reentrancy guard.

Contract below will call back into the contract ReentrancyGuard.

Write code that will prevent reentrancy.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TestReentrancyGuard {
    // Maximum number of times fallback will call back msg.sender
    uint public immutable max;
    // Actual amount of time fallback was executed
    uint public count;

    constructor(uint _max) {
        max = _max;
    }

    fallback() external {
        if (count < max) {
            count += 1;
            (bool success, ) = msg.sender.call(
                abi.encodeWithSignature("test(address)", address(this))
            );
            require(success, "call back failed");
        }
    }
}

contract ReentrancyGuard {
    // Count stores number of times the function test was called
    uint public count;
    bool private locked;

    modifier lock() {
        require(!locked, "locked");
        locked = true;
        _;
        locked = false;
    }

    function test(address _contract) external lock {
        (bool success, ) = _contract.call("");
        require(success, "tx failed");
        count += 1;
    }
}

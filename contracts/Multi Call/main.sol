/*
MultiCall is a handy contract that queries multiple contracts in a single function call and returns all the results.

This function can be modified to work with call or delegatecall.

However for this challenge we will use staticcall to query other contracts.

Here is the contract that will be called.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TestMultiCall {
    function test(uint _i) external pure returns (uint) {
        return _i;
    }
}

Staticcall
The syntax to query contracts using staticcall is similar to using call

(bool success, bytes memory response) = contractToCall.staticcall(data)

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiCall {
    function multiCall(
        address[] calldata targets,
        bytes[] calldata data
    ) external view returns (bytes[] memory) {
        bytes[] memory results = new bytes[](data.length);

        return results;
    }
}

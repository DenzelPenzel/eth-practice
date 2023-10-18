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


Task:
    - Complete the function

        function multiCall(address[] calldata targets, bytes[] calldata data)

        This function should

        For each address in targets use staticcall to call targets[i] passing data[i].
        Fail if any call to address in targets fails
        Save the result in results bytes array.
        Return all the results stored in results.
        Fail if targets.length differs from data.length.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiCall {
    function multiCall(
        address[] calldata targets,
        bytes[] calldata data
    ) external view returns (bytes[] memory) {
        require(targets.length == data.length, "target length != data length");

        bytes[] memory results = new bytes[](data.length);

        for (uint i = 0; i < targets.length; i++) {
            (bool success, bytes memory response) = targets[i].staticcall(data[i]);
            require(success, "call failed");
            results[i] = response;
        }

        require(results.length == data.length, "res != data");

        return results;
    }
}

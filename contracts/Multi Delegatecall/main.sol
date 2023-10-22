/*

Let's say you need to call two functions in a smart contract. You will need to send two transactions.

MultiDelegatecall is a handy smart contract that enables a contract to execute multiple functions in a single transaction.


Tasks:
    - Complete `multiDelegatecall`
        function multiDelegatecall(bytes[] calldata data)
            external
            payable
            returns (bytes[] memory results)
        {
            // code here
        }

        This function takes in an array of bytes.

        For each array element in data, execute delegatecall to itself address(this), passing in data[i].

        Throw an error if any of the delegatecall fails.

        If delegatecall is successful, store the output into results[i].

    - Let TestMultiDelegatecall inherit MultiDelegatecall.
        Now we can call multiDelegatecall on TestMultiDelegatecall.

        This will enable func1 and func2 to be called sequentially in a single transactions.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TestMultiDelegatecall {
    event Log(address caller, string func, uint i);

    function func1(uint x, uint y) external {
        emit Log(msg.sender, "func1", x + y);
    }

    function func2() external returns (uint) {
        emit Log(msg.sender, "func2", 2);
        return 111;
    }
}

contract MultiDelegatecall {
    function multiDelegatecall(
        bytes[] calldata data
    ) external payable returns (bytes[] memory results) {
        // code here
        results = new bytes[](data.length);
        for (uint i = 0; i < data.length; i++) {
            (bool success, bytes memory res) = address(this).delegatecall(
                data[i]
            );
            if (!success) {
                revert DelegatecallFailed();
            }
            results[i] = res;
        }
        return results;
    }
}

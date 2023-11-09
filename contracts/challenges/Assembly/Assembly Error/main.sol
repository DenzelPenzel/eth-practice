/*
Error in assembly.

Tasks:
    - Complete the function

        function revert_if_zero(uint x) public pure {
            // Code here
        }

        Revert if x is 0.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssemblyError {
    function yul_revert(uint x) public pure {
        assembly {
            // revert(p, s) - end execution
            //                revert state changes
            //                return data mem[p…(p+s))
            if gt(x, 10) {
                revert(0, 0)
            }
        }
    }

    function revert_if_zero(uint x) public pure {
        // Code here
    }
}

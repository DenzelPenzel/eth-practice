/*

Assign a variable using assembly.

- Complete the function
    function hello() public pure returns (uint z) {
        // Code here
    }

    Use assembly to assign z to 123
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssemblyVariable {
    function yul_let() public pure returns (uint z) {
        assembly {
            // Language used for assembly is called Yul
            // Local variables
            let x := 123
            z := 456
        }
    }

    function hello() public pure returns (uint z) {
        // Code here
    }
}

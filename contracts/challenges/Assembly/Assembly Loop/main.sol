/*
For loop and while loop in assembly.


Tasks:
    - Complete the function
        function sum(uint n) public pure returns (uint z) {
        // Code here
        }

        Use assembly to calculate the sum of all integers from 1 to n - 1.


    - Complete the function
        function pow2k(uint x, uint n) public pure returns (uint z) {
            require(x > 0, "x = 0");
            // Code here
        }

        This function will calculate x ** n where n = 2**k.

        You can assume that x > 0 and that x**n is small enough that no overflow will occur.
        Revert if n is not a power of 2, n != 2**k for some integer k.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssemblyLoop {
    function yul_for_loop() public pure returns (uint z) {
        assembly {
            for {
                let i := 0
            } lt(i, 10) {
                i := add(i, 1)
            } {
                z := add(z, 1)
            }
        }
    }

    function yul_while_loop() public pure returns (uint z) {
        assembly {
            let i := 0
            for {

            } lt(i, 5) {

            } {
                i := add(i, 1)
                z := add(z, 1)
            }
        }
    }

    function sum(uint n) public pure returns (uint z) {
        // Code here
    }

    // Calculate x**n where n = 2**k
    // x > 0
    // No overflow check
    function pow2k(uint x, uint n) public pure returns (uint z) {
        require(x > 0, "x = 0");
        // Code here
    }
}

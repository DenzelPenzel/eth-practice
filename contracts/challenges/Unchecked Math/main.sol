/*

Underflows and overflows results in an error in Solidity. 

However this behaviour can be disabled by writing your code inside unchecked.

Unchecked math can save gas.


Tasks:
    - Complete the function sub using unchecked to disable underflow check.
        function sub(uint x, uint y) external pure returns (uint) {}

    - Complete the function sumOfCubes
        function sumOfCubes(uint x, uint y) external pure returns (uint) {}
            - Return the sum of cubes x * x * x + y * y * y
            - Use unchecked to disable overflow check
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UncheckedMath {
    function add(uint x, uint y) external pure returns (uint) {
        // 22291 gas
        // return x + y;

        // 22103 gas
        unchecked {
            return x + y;
        }
    }

    function sub(uint x, uint y) external pure returns (uint) {
        // 22329 gas
        // return x - y;
        // Code
    }

    function sumOfSquares(uint x, uint y) external pure returns (uint) {
        // Wrap complex math logic inside unchecked
        unchecked {
            uint x2 = x * x;
            uint y2 = y * y;

            return x2 + y2;
        }
    }

    function sumOfCubes(uint x, uint y) external pure returns (uint) {
        // Code
    }
}

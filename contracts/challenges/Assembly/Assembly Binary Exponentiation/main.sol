/*
Implement binary exponentiation in assembly. Binary exponentiation is a fast way to compute x**n.

Tasks:
    - Complete the function
        function rpow(
            uint256 x,
            uint256 n,
            uint256 b
        ) public pure returns (uint256 z) {
            assembly {
                switch x
                // x = 0
                case 0 {
                    switch n
                    // n = 0 --> x**n = 0**0 --> 1
                    case 0 { z := b }
                    // n > 0 --> x**n = 0**n --> 0
                    default { z := 0 }
                }
                default {
                    // Code here
                }
            }
        }

        Use binary exponentiation to calculate x**n.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssemblyBinExp {
    // Binary exponentiation to calculate x**n
    function rpow(
        uint256 x,
        uint256 n,
        uint256 b
    ) public pure returns (uint256 z) {
        assembly {
            switch x
            // x = 0
            case 0 {
                switch n
                // n = 0 --> x**n = 0**0 --> 1
                case 0 {
                    z := b
                }
                // n > 0 --> x**n = 0**n --> 0
                default {
                    z := 0
                }
            }
            default {
                // Code here
            }
        }
    }
}

/*
Take a look at the example of for and while loop on the right.

Tasks: 

Complete the function sum.

This function should return the sum of all numbers up to _n including _n.

For example sum(5) should return 1 + 2 + 3 + 4 + 5 = 15.

*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ForAndWhileLoops {
    function loop() external pure {
        // for loop
        for (uint i = 0; i < 10; i++) {
            if (i == 3) {
                // Skip to next iteration with continue
                continue;
            }
            if (i == 5) {
                // Exit loop with break
                break;
            }
        }

        // while loop
        uint j;
        while (j < 10) {
            j++;
        }
    }

    function sum(uint _n) external pure returns (uint) {
        // Write your code here
        uint res = 0;
        for (uint i = 1; i <= _n; i++) {
            res += i;
        }
        return res;
    }
}

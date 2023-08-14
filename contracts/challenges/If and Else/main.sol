/*
Let's take a look at how to write a conditional statement using if, else if, and else.

Ternary operator, short hand syntax for if / else is available in Solidity.

Here is an example

// condition ? value to return if true : value to return if false
y = x > 1 ? 10 : 20;

Tasks:
    1) Complete the function exercise_1.
    It should return 1 if _x is greater than 0, else return 0.

    2) Complete the function exercise_2.
    If _x is greater than 0 then return 1, else return 0.
    Use the ternary operator ?.

*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IfElse {
    function ifElse(uint _x) external pure returns (uint) {
        if (_x < 10) {
            return 1;
        } else if (_x < 20) {
            return 2;
        } else {
            return 3;
        }
    }

    function ternaryOperator(uint _x) external pure returns (uint) {
        // condition ? value to return if true : value to return if false
        return _x > 1 ? 10 : 20;
    }

    function exercise_1(uint _x) external pure returns (uint) {
        // Write your code here
        return _x > 0 ? 1 : 0;
    }

    function exercise_2(uint _x) external pure returns (uint) {
        // Write your code here
        return _x > 0 ? 1 : 0;
    }
}

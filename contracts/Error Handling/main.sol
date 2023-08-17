/*

Solidity has 3 ways to throw an error, require, revert and assert.

require is used to validate inputs and check conditions before and after execution.
revert is like require but more handy when the condition to check is nested in several if statements.
assert is used to check invariants, code that should never be false. 
       Failing assertion probably means that there is a bug.

An error will undo all changes made during a transaction.

Task: 
    The function div divides the inputs x by y and returns the quotient.

    But division by 0 is invalid.

    Complete the function div by checking that y is greater than 0.

    Throw an error message "div by 0" if y is 0.
*/


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ErrorHandling {
    function testRequire(uint _i) external pure {
        // Require should be used to validate conditions such as:
        // - inputs
        // - conditions before execution
        // - return values from calls to other functions
        require(_i <= 10, "i > 10");
    }

    function testRevert(uint _i) external pure {
        // Revert is useful when the condition to check is complex.
        // This code does the exact same thing as the example above
        if (_i > 10) {
            revert("i > 10");
        }
    }

    uint num;

    function testAssert() external view {
        // Assert should only be used to test for internal errors,
        // and to check invariants.

        // Here we assert that num is always equal to 0
        // since it is impossible to update the value of num
        assert(num == 0);
    }

    function div(uint x, uint y) external pure returns (uint) {
        // Write your code here
        require(y > 0, "div by 0");
        return x / y;
    }
}

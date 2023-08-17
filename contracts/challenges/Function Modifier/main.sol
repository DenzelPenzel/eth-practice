/*
Function modifiers are reuseable code that can be run before and / or after a function call.

Here are some examples of how they are used.

Restrict access
Validate inputs
Check states right before and after a function call

Tasks:
1) Add the modifier whenNotPaused to dec() so that count can only be decreased if paused is false.

2) Create a modifier named whenPaused, which checks that the state variable pause is true.
   It should throw an error message "not paused" if paused is false.

3) Add external function reset which will reset count to 0.
   Use to modifier whenPaused from the previous task to check 
   that this function can only be executed if paused is true
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FunctionModifier {
    bool public paused;
    uint public count;

    // Modifier to check if not paused
    modifier whenNotPaused() {
        require(!paused, "paused");
        // Underscore is a special character only used inside
        // a function modifier and it tells Solidity to
        // execute the rest of the code.
        _;
    }
    
    modifier whenPaused() {
        require(paused, "not paused");
        _;
    }

    function setPause(bool _paused) external {
        paused = _paused;
    }

    // This function will throw an error if paused
    function inc() external whenNotPaused {
        count += 1;
    }

    function dec() external whenNotPaused {
        count -= 1;
    }

    // Modifiers can take inputs.
    // Here is an example to check that x is < 10
    modifier cap(uint _x) {
        require(_x < 10, "x >= 10");
        _;
    }

    function incBy(uint _x) external whenNotPaused cap(_x) {
        count += _x;
    }
    
    function reset() external whenPaused {
        count = 0;
    }

    // Modifiers can execute code before and after the function.
    modifier sandwich() {
        // code here
        _;
        // more code here
    }
}

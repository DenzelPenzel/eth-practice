/*
Functions and state variables must declare whether they are accessible by other contracts.

Fucntions can be declared as
    public - can be called by anyone and any contract
    private - can only be called inside the contract
    internal - can be called inside the contract and child contracts
    external - can only be called from outside the contract


State variables can be declared as public, private, or internal but not external.

Taksk:

Inside the function test in VisibilityChild, 
add up all the state variables and functions that can be directly 
called inside VisibilityChild and return the sum.

Exclude call to this.externalFunc() 
from the sum since it cannot be called directly inside test() by externalFunc().

*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// visibility - public, private, internal, external
contract VisibilityBase {
    // State variables can be one of private, internal or public.
    uint private x = 0;
    uint internal y = 1;
    uint public z = 2;

    // Private function can only be called
    // - inside this contract
    // Contracts that inherit this contract cannot call this function.
    function privateFunc() private pure returns (uint) {
        return 0;
    }

    // Internal function can be called
    // - inside this contract
    // - inside contracts that inherit this contract
    function internalFunc() internal pure returns (uint) {
        return 100;
    }

    // Public functions can be called
    // - inside this contract
    // - inside contracts that inherit this contract
    // - by other contracts and accounts
    function publicFunc() public pure returns (uint) {
        return 200;
    }

    // External functions can only be called
    // - by other contracts and accounts
    function externalFunc() external pure returns (uint) {
        return 300;
    }

    function examples() external view {
        // Access state variables
        x + y + z;

        // Call functions, cannot call externalFunc()
        privateFunc();
        internalFunc();
        publicFunc();

        // Actually you can call an external function with this syntax.
        // This is bad code.
        // Instead of making an internal call to the function, it does an
        // external call into this contract. Hence using more gas than necessary.
        this.externalFunc();
    }
}

contract VisibilityChild is VisibilityBase {
    function examples2() external view {
        // Access state variables (internal and public)
        y + z;

        // Call functions (internal and public)
        internalFunc();
        publicFunc();
    }

    function test() external view returns (uint) {
        uint xx = publicFunc() + internalFunc();
        return xx + y + z;
    }
}

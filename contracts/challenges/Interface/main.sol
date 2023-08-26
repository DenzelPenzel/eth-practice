/*

Interfaces enable a contract to call other contracts without having its code.

Tasks:
    - Complete dec(address _test) inside CallInterface.
    - This function will call TestInterface.dec using the interface ITestInterface.
    - You will need to declare a new function inside ITestInterface.
    
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// You know what functions you can call, so you define an interface to TestInterface.
interface ITestInterface {
    function count() external view returns (uint);

    function inc() external;

    function dec() external;
}

// Contract that uses TestInterface interface to call TestInterface contract
contract CallInterface {
    function examples(address _test) external {
        ITestInterface(_test).inc();
        uint count = ITestInterface(_test).count();
    }

    function dec(address _test) external {
        // Write your code here
        ITestInterface(_test).dec();
    }
}

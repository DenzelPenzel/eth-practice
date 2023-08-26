/*

Here is an example of a contract calling another contract.

This is the contract that is called for this challenge.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TestContract {
    uint public x;
    uint public value = 123;

    function setX(uint _x) external {
        x = _x;
    }

    function getX() external view returns (uint) {
        return x;
    }

    function setXandReceiveEther(uint _x) external payable {
        x = _x;
        value = msg.value;
    }

    function getXandValue() external view returns (uint, uint) {
        return (x, value);
    }

    function setXtoValue() external payable {
        x = msg.value;
    }

    function getValue() external view returns (uint) {
        return value;
    }
}

Tasks:
    - Complete setXwithEther(address _addr).
      This function will call TestContract.setXtoValue, sending all of Ether sent to setXwithEther.

    - Complete getValue(address _addr). 
      This function will call TestContract.getValue and return the output.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./TestContract.sol";

contract CallTestContract {
    function setX(TestContract _test, uint _x) external {
        _test.setX(_x);
    }

    function setXfromAddress(address _addr, uint _x) external {
        TestContract test = TestContract(_addr);
        test.setX(_x);
    }

    function getX(address _addr) external view returns (uint) {
        uint x = TestContract(_addr).getX();
        return x;
    }

    function setXandSendEther(TestContract _test, uint _x) external payable {
        _test.setXandReceiveEther{value: msg.value}(_x);
    }

    function getXandValue(address _addr) external view returns (uint, uint) {
        (uint x, uint value) = TestContract(_addr).getXandValue();
        return (x, value);
    }

    function setXwithEther(address _addr) external payable {
        TestContract(_addr).setXtoValue{value: msg.value}();
    }

    function getValue(address _addr) external view returns (uint) {
        uint x = TestContract(_addr).getValue();
        return x;
    }
}

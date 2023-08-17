/*
Mapping is not iterable in Solidity.

Tasks:

- Write function first() which will return the balance of the first address to be inserted.
  You can assume that the array keys is not empty

- Write function last() which will return the balance of the last address to be inserted.
  You can assume that the array keys is not empty.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IterableMapping {
    mapping(address => uint) public balances;
    mapping(address => bool) public inserted;
    address[] public keys;

    function set(address _addr, uint _bal) external {
        balances[_addr] = _bal;

        if (!inserted[_addr]) {
            inserted[_addr] = true;
            keys.push(_addr);
        }
    }

    function get(uint _index) external view returns (uint) {
        address key = keys[_index];
        return balances[key];
    }

    function first() external view returns (uint) {
        // Write your code here
        address key = keys[0];
        return balances[key];
    }

    function last() external view returns (uint) {
        // Write your code here
        address key = keys[keys.length - 1];
        return balances[key];
    }
}

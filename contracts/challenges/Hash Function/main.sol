/*
keccak256 is a cryptographic hash funciton commonly used in Solidity.

Some use cases are:
    Creating a deterministic unique ID from inputs
    Cryptographic signatures
    Commit reveal scheme

Here you will learn the basics, how to use keccak256.


Tasks: 
    - Complete getHash. This function will return the keccak256 hash of two inputs _addr and _num.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HashFunc {
    function hash(
        string memory _text,
        uint _num,
        address _addr
    ) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(_text, _num, _addr));
    }

    function getHash(address _addr, uint _num) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(_addr, _num));
    }
}

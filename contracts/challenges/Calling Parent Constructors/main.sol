/*
There are 2 ways to pass parameters into parent constructors.


Task:
    Create contract W that inherits both S and T.

    Constructor for W takes a single input string. This input must be passed into the parent contract T .

    Initialize contract S with the string "S".

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract S {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract T {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// 2 ways to call parent constructors
contract U is S("S"), T("T") {

}

contract V is S, T {
    // Pass the parameters here in the constructor,
    constructor(string memory _name, string memory _text) S(_name) T(_text) {}
}

contract W is S, T {
    constructor(string memory _text) S("S") T(_text) {}
}
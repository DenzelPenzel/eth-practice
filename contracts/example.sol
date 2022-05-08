//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./storage-example.sol";

contract A {
    function setA(uint256 _a) public {
        // always safe against someone act to rewrite storage
        StorageExample storage s = Storage.get();
        s.a = _a;
    }

    // function getA() public view returns (uint256) {
    //     return s.a;
    // }
}

contract B {
    // Data storing according ordering
    // Data trying compact as much as possible
    // uint256 b; // 0x0000000000000000000000000000000000000000000000000000000000000004
    // uint8 c; // 0x00000000000000000000c5a5c42992decbae36851359345fe25997f5c42df5[45]
    // uint8 d; // 0x00000000000000000000c5a5c42992decbae36851359345fe25997f5c42d[f5]45
    //address ContractA; // 0x00000000000000000000[c5a5c42992decbae36851359345fe25997f5c42d]f545
    StorageExample s;

    constructor(address _A) {
        s.b = 4;
        s.c = 0x45;
        s.d = 0xF5;
        s.ContractA = _A;
    }

    function setB(uint256 _b) public {
        s.b = _b;
        // A(ContractA).setA(_a + 1);

        // Fallback functions in the separate contract 
        // Delegate calls out of the contract. Use our own storage.
        // Exec in the current context
        (bool success, bytes memory bbb) = s.ContractA.delegatecall(
            abi.encodeWithSignature("setA(uint256)", _b + 1)
        );

        console.log("success", success);
    }

    function getB() public view returns (uint256) {
        return s.b;
    }
}

//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

struct StorageExample {
    uint256 a;
    uint256 b;
    uint8 c;
    uint8 d;
    address ContractA;
}

library Storage {
    // can't overwrite it
    // bytes32 KEY = keccak256("test-storage-location");

    function get() internal pure returns (StorageExample storage s) {
        // bytes32 k = KEY;
        assembly {
            s.slot := "123"
        }
    }
}

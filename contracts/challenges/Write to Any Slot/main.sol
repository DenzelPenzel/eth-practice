/*
State variables are stored in slots. There are 2 ** 256 - 1 slots, each slot can store up to 32 bytes.

We can write to any slot using assembly. This technique is used in proxy contracts to store the address of the implementation contract.

Write a smart contract that can store an address in any slot.


Tasks:
    - Define a struct inside the library StorageSlot
        struct AddressSlot {
            address value;
        }

        We need to wrap address in a struct so that it can be passed around as a storage pointer.


    - Declare the function below inside StorageSlot
        function getAddressSlot(
            bytes32 slot
        ) internal pure returns (AddressSlot storage pointer) {}

        This function will return the storage pointer at the slot from the input.

        Storage pointer is obtained by the following code

        assembly {
            // Get the pointer to AddressSlot stored at slot
            pointer.slot := slot
        }

        Note the variable pointer is declared in the output of this function AddressSlot storage pointer


    - Complete the function write inside TestSlot
        This function will store the address from the input _addr at the slot TEST_SLOT.

        Use the library StorageSlot.getAddressSlot(TEST_SLOT) to get the storage pointer at TEST_SLOT.


    - Complete the function get inside TestSlot
        This function will get the address stored at TEST_SLOT.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library StorageSlot {
    // Code here
}

contract TestSlot {
    bytes32 public constant TEST_SLOT = keccak256("TEST_SLOT");

    function write(address _addr) external {
        // Code here
    }

    function get() external view returns (address) {
        // Code here
    }
}

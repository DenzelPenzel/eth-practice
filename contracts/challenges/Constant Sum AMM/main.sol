/*

Constant sum AMM (automated market maker) is a decentralized exchange that trades two tokens in the contract.

Users will be able to add liquidity and earn swap fees, swap tokens and remove liquidity.

Why is it called constant sum?
    The amount of token to come out of the trade is determined by the following equation.

X = amount of token A in the contract
Y = amount of token B in the contract
K = a constant that satisfies the following equation

X + Y = K

X + Y equals some constant K, hence the name constant sum.

This equation X + Y = K must be true before and after every swap.

dx = Amount of token A that came in from the swap
dy = Amount of token B that went out from the swap

# Before the trade
X + Y = K

# After the trade
X + dx + Y - dy = K

Since X + Y = K, replace K in the second equation X + dx + Y - dy = K with X + Y

X + dx + Y - dy = X + Y

Cancel out X and Y on both side of the equation

dx - dy = 0

or simply

dx = dy

In other words, the amount of token coming in from a swap must equal the amount of token going out.


Tasks:
    - Complete internal functions _mint
        function _mint(address _to, uint _amount) private {}

        The function _mint mints must increment totalSupply and balanceOf _to by _amount.


    - Complete internal functions _burn

        function _burn(address _from, uint _amount) private {}

        The function _burn must decrement totalSupply and balanceOf _from by _amount.


    - Complete function addLiquidity

        function addLiquidity(uint _amount0, uint _amount1)
            external
            returns (uint shares)
        {}

        addLiquidity deposits token0 and token1 from msg.sender into the contract and mints appropriate shares to msg.sender.

        This function must

        Transfers token0 and token1 from msg.sender into the contract.
        Mint shares proportional to the increase in liquidity to msg.sender. Liquidity is the total amount of tokens in the contract. (reserve0 + reserve1).
        This function must fail if shares to mint is 0.
        Update reserve0 and reserve1. These state variables internally track the amount of token0 and token1 in this contract.


    - Complete function swap

        function swap(address _tokenIn, uint _amountIn)
            external
            returns (uint amountOut)
        {}

        swap trades one token for another (token0 for token1 or token1 for token0).

        This function must

        Fail if _tokenIn is neither token0 nor token1.
        Transfer _amountIn of tokenIn from msg.sender into the contract.
        Trading fee is 0.3%. In other words, amount to transfer out is 99.7% of _amountIn.
        Transfer appropriate amount of token out to msg.sender. Appropriate amount equals amount in minus trading fee.
        Update reserve0 and reserve1.


    - Complete function removeLiquidity

        function removeLiquidity(uint _shares) external returns (uint d0, uint d1) {}

        removeLiquidity withdraws token0 and token1 out to msg.sender and burns msg.sender's shares.

        This function must

        Transfers token0 and token1 out to msg.sender.
        Amounts of token to transfer out, d0 and d1 must be proportional to the amount of _shares to burn.
        Update reserve0 and reserve1.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";

contract CSAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;
    uint public reserve1;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1) {
        // NOTE: This contract assumes that token0 and token1
        // both have same decimals
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint _amount) private {
        // Write code here
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint _amount) private {
        // Write code here
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function swap(
        address _tokenIn,
        uint _amountIn
    ) external returns (uint amountOut) {
        // Write code here
        require(
            _tokenIn == address(token0) || _tokenIn == address(token1),
            "invalid token"
        );

        bool isToken0 = _tokenIn == address(token0);

        (IERC20 tokenIn, IERC20 tokenOut, uint resIn, uint resOut) = isToken0
            ? (token0, token1, reserve0, reserve1)
            : (token1, token0, reserve1, reserve0);

        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        uint amountIn = tokenIn.balanceOf(address(this)) - resIn;

        // 0.3% fee
        amountOut = (amountIn * 997) / 1000;

        (uint res0, uint res1) = isToken0
            ? (resIn + amountIn, resOut - amountOut)
            : (resOut - amountOut, resIn + amountIn);

        _update(res0, res1);
        tokenOut.transfer(msg.sender, amountOut);
    }

    function addLiquidity(
        uint _amount0,
        uint _amount1
    ) external returns (uint shares) {
        // Write code here
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);

        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));

        uint d0 = bal0 - reserve0;
        uint d1 = bal1 - reserve1;

        uint shares;
         /*
            a = amount in
            L = total liquidity
            s = shares to mint
            T = total supply

            s should be proportional to increase from L to L + a
            (L + a) / L = (T + s) / T

            s = a * T / L
        */
        if (totalSupply > 0) {
            shares = ((d0 + d1)* totalSupply) / (reserve0 + reserve1);
        } else {
            shares = (d0 + d1);
        }
        
        require(shares > 0, "shares <= 0");

        _mint(msg.sender, shares);
        _update(bal0, bal1);
    }

    function _update(uint _res0, uint _res1) private {
        reserve0 = _res0;
        reserve1 = _res1;
    }

    function removeLiquidity(uint _shares) external returns (uint d0, uint d1) {
        // Write code here
        /*
            a = amount out
            L = total liquidity
            s = shares
            T = total supply

            a / L = s / T

            a = L * s / T
            = (reserve0 + reserve1) * s / T
        */
        d0 = _shares * reserve0 / totalSupply;
        d1 = _shares * reserve1 / totalSupply;

        _burn(msg.sender, _shares);
        _update(reserve0 - d0, reserve1 - d1);

        if (d0 > 0) {
            token0.transfer(msg.sender, d0);
        }

        if (d1 > 0) {
            token1.transfer(msg.sender, d1);
        }

    }
}

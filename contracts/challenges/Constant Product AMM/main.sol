/*
Constant product AMM (automated market maker) is a decentralized exchange where 2 tokens are traded.

The price of the tokens are determined by a mathematical equation
    X = amount of token A in the contract
    Y = amount of token B in the contract
    K = a constant that satisfies the following equation

    XY = K

XY equals some constant K, hence the name constant product.


Video: https://www.youtube.com/watch?v=QNPyFs8Wybk

Task:
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

        This function must:
            - Transfers token0 and token1 from msg.sender into the contract.
            - This function must fail if incorrect amounts of tokens are provided. Incorrect amounts are quantities that will change the current price of tokens.
            - Mint shares proportional to the increase in liquidity to msg.sender.
            - This function must fail if shares to mint is 0.
            - Update reserve0 and reserve1. These state variables internally track the amount of token0 and token1 in this contract.


    - Complete function swap
        function swap(address _tokenIn, uint _amountIn)
            external
            returns (uint amountOut)
        {}

        swap trades one token for another (token0 for token1 or token1 for token0).

        This function must
            - Fail if _tokenIn is neither token0 nor token1.
            - Transfer _amountIn of tokenIn from msg.sender into the contract.
            - Trading fee is 0.3%. In other words, amount in is calculated to be 99.7% of _amountIn.
            - Transfer appropriate amount of token out to msg.sender.
            - Update reserve0 and reserve1.


    - Complete function removeLiquidity
        function removeLiquidity(uint _shares)
            external
            returns (uint amount0, uint amount1)
        {}

        removeLiquidity withdraws token0 and token1 out to msg.sender and burns msg.sender's shares.

        This function must
            - Transfers token0 and token1 out to msg.sender.
            - Amounts of token to transfer out, amount0 and amount1 must be proportional to the amount of _shares to burn.
            - This function must fail if either amount0 or amount1 is 0
            - Update reserve0 and reserve1.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";

contract CPAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;
    uint public reserve1;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function _update(uint _reserve0, uint _reserve1) private {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    function swap(
        address _tokenIn,
        uint _amountIn
    ) external returns (uint amountOut) {
        require(
            _tokenIn == address(token0) || _tokenIn == address(token1),
            "invalid token"
        );
        require(_amountIn > 0, "amount in = 0");

        bool isToken0 = _tokenIn == address(token0);
        (
            IERC20 tokenIn,
            IERC20 tokenOut,
            uint reserveIn,
            uint reserveOut
        ) = isToken0
                ? (token0, token1, reserve0, reserve1)
                : (token1, token0, reserve1, reserve0);

        tokenIn.transferFrom(msg.sender, address(this), _amountIn);

        /*
        How many dy for dx?

        xy = k
        (x + dx)(y - dy) = k
        y - dy = k / (x + dx)
        y - k / (x + dx) = dy
        y - xy / (x + dx) = dy
        (yx + ydx - xy) / (x + dx) = dy
        ydx / (x + dx) = dy
        */
        // 0.3% fee
        uint amountInWithFee = (_amountIn * 997) / 1000;
        amountOut =
            (reserveOut * amountInWithFee) /
            (reserveIn + amountInWithFee);

        tokenOut.transfer(msg.sender, amountOut);

        _update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );
    }

    function addLiquidity(
        uint _amount0,
        uint _amount1
    ) external returns (uint shares) {
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);

        /*
        How many dx, dy to add?

        xy = k
        (x + dx)(y + dy) = k'

        No price change, before and after adding liquidity
        x / y = (x + dx) / (y + dy)

        x(y + dy) = y(x + dx)
        x * dy = y * dx

        x / y = dx / dy
        dy = y / x * dx
        */
        if (reserve0 > 0 || reserve1 > 0) {
            require(
                reserve0 * _amount1 == reserve1 * _amount0,
                "x / y != dx / dy"
            );
        }

        /*
        How many shares to mint?

        f(x, y) = value of liquidity
        We will define f(x, y) = sqrt(xy)

        L0 = f(x, y)
        L1 = f(x + dx, y + dy)
        T = total shares
        s = shares to mint

        Total shares should increase proportional to increase in liquidity
        L1 / L0 = (T + s) / T

        L1 * T = L0 * (T + s)

        (L1 - L0) * T / L0 = s 
        */

        /*
        Claim
        (L1 - L0) / L0 = dx / x = dy / y

        Proof
        --- Equation 1 ---
        (L1 - L0) / L0 = (sqrt((x + dx)(y + dy)) - sqrt(xy)) / sqrt(xy)
        
        dx / dy = x / y so replace dy = dx * y / x

        --- Equation 2 ---
        Equation 1 = (sqrt(xy + 2ydx + dx^2 * y / x) - sqrt(xy)) / sqrt(xy)

        Multiply by sqrt(x) / sqrt(x)
        Equation 2 = (sqrt(x^2y + 2xydx + dx^2 * y) - sqrt(x^2y)) / sqrt(x^2y)
                   = (sqrt(y)(sqrt(x^2 + 2xdx + dx^2) - sqrt(x^2)) / (sqrt(y)sqrt(x^2))
        
        sqrt(y) on top and bottom cancels out

        --- Equation 3 ---
        Equation 2 = (sqrt(x^2 + 2xdx + dx^2) - sqrt(x^2)) / (sqrt(x^2)
        = (sqrt((x + dx)^2) - sqrt(x^2)) / sqrt(x^2)  
        = ((x + dx) - x) / x
        = dx / x

        Since dx / dy = x / y,
        dx / x = dy / y

        Finally
        (L1 - L0) / L0 = dx / x = dy / y
        */
        if (totalSupply == 0) {
            shares = _sqrt(_amount0 * _amount1);
        } else {
            shares = _min(
                (_amount0 * totalSupply) / reserve0,
                (_amount1 * totalSupply) / reserve1
            );
        }
        require(shares > 0, "shares = 0");
        _mint(msg.sender, shares);

        _update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );
    }

    function removeLiquidity(
        uint _shares
    ) external returns (uint amount0, uint amount1) {
        /*
        Claim
        dx, dy = amount of liquidity to remove
        dx = s / T * x
        dy = s / T * y

        Proof
        Let's find dx, dy such that
        v / L = s / T
        
        where
        v = f(dx, dy) = sqrt(dxdy)
        L = total liquidity = sqrt(xy)
        s = shares
        T = total supply

        --- Equation 1 ---
        v = s / T * L
        sqrt(dxdy) = s / T * sqrt(xy)

        Amount of liquidity to remove must not change price so 
        dx / dy = x / y

        replace dy = dx * y / x
        sqrt(dxdy) = sqrt(dx * dx * y / x) = dx * sqrt(y / x)

        Divide both sides of Equation 1 with sqrt(y / x)
        dx = s / T * sqrt(xy) / sqrt(y / x)
           = s / T * sqrt(x^2) = s / T * x

        Likewise
        dy = s / T * y
        */

        // bal0 >= reserve0
        // bal1 >= reserve1
        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));

        amount0 = (_shares * bal0) / totalSupply;
        amount1 = (_shares * bal1) / totalSupply;
        require(amount0 > 0 && amount1 > 0, "amount0 or amount1 = 0");

        _burn(msg.sender, _shares);
        _update(bal0 - amount0, bal1 - amount1);

        token0.transfer(msg.sender, amount0);
        token1.transfer(msg.sender, amount1);
    }

    function _sqrt(uint y) private pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function _min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }
}

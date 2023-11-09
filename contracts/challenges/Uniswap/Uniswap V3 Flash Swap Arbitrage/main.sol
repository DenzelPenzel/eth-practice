/*

300 points
Arbitrage between USDC/ETH 0.3% fee pool and USDC/ETH 0.05% fee pool.

For this challenge, we will

Borrow USDC from one pool
Swap USDC back to WETH in another pool
Repay first pool with WETH
If the amount of WETH bought back in step 2 is greater than the amount repaid in step 3,
then there is profit from the the arbitrage. Otherwise there was a loss.


Tasks:
    - Complete the function
        function flashSwap(address pool0, uint24 fee1, uint wethAmountIn) external {}

        This function will start the arbitrage by borrowing USDC from pool0.

        pool0 will send USDC to this contract and then call uniswapV3SwapCallback.

        Inside uniswapV3Callback, we will need to send wethAmountIn amount of WETH to pool0.
            - Encode data to be later decoded inside uniswapV3SwapCallback. The data to encode are msg.sender, pool0 and fee1.
        
        bytes memory data = abi.encode(msg.sender, pool0, fee1);
            - Initiate the arbitrage by calling IUniswapV3Pool.swap on pool0. Below are the inputs to pass.
        
        IUniswapV3Pool.swap function inputs
                                                                                    Input to use
        recipient	        Address to receive output token	                        address(this)
        zeroForOne	        Direction of the swap, true for token0 to token1	    false
        amountSpecified	    Amount to swap	                                        int(wethAmountIn)
        sqrtPriceLimitX96	Limit for the change in price	                        MAX_SQRT_RATIO - 1
        data	            Data to be passed to uniswapV3SwapCallback	            data

        In USDC/ETH pools token0 is USDC and token1 is WETH. We are swapping WETH for USDC so zeroForOne is false.

    - Complete the internal function
        function _swap(
            address tokenIn,
            address tokenOut,
            uint24 fee,
            uint amountIn
        ) private returns (uint amountOut) {}

        Swap tokenIn for tokenOut by calling router.exactInputSingle


    - Complete the function
        function uniswapV3SwapCallback(
            int amount0,
            int amount1,
            bytes calldata data
        ) external {}

        This function is called by pool0 immediately after we call IUniswapV3Pool.swap.

        amount0 is amount of USDC we borrowed. This variable will be a negative number since USDC is taken out of the pool.

        amount1 is amount of WETH we owe to pool0.

        data is the data we've encoded inside the function flashSwap.
            - Decode data
            (address caller, address pool0, uint24 fee1) = abi.decode(
                data,
                (address, address, uint24)
            );

            - Call _swap to swap USDC for WETH
            - Repay WETH back to pool0. If there is profit, transfer to caller. Otherwise transfer the loss from caller.
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import and use hardhat/console.sol to debug your contract
// import "hardhat/console.sol";

import "./IERC20.sol";
import "./ISwapRouter.sol";
import "./IUniswapV3Pool.sol";

contract UniswapV3FlashSwap {
    ISwapRouter constant router =
        ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

    uint160 internal constant MIN_SQRT_RATIO = 4295128739;
    uint160 internal constant MAX_SQRT_RATIO =
        1461446703485210103287273052203988822378723970342;

    address private constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IERC20 private constant usdc = IERC20(USDC);
    IERC20 private constant weth = IERC20(WETH);

    function flashSwap(address pool0, uint24 fee1, uint wethAmountIn) external {
        // Code
    }

    function _swap(
        address tokenIn,
        address tokenOut,
        uint24 fee,
        uint amountIn
    ) private returns (uint amountOut) {
        // Code
    }

    function uniswapV3SwapCallback(
        int amount0,
        int amount1,
        bytes calldata data
    ) external {
        // Code
    }
}

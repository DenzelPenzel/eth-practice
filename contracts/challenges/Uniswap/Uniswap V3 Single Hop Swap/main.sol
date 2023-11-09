/*

This challenge introduces 2 functions to perform single hop swaps on Uniswap V3

exactInputSingle - Sell all of input token.
exactOutputSingle - Buy specific amount of output token.
Here is the interface for Uniswap V3 router, ISwapRouter.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ISwapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint deadline;
        uint amountIn;
        uint amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(
        ExactInputSingleParams calldata params
    ) external payable returns (uint amountOut);

    struct ExactInputParams {
        bytes path;
        address recipient;
        uint deadline;
        uint amountIn;
        uint amountOutMinimum;
    }

    function exactInput(
        ExactInputParams calldata params
    ) external payable returns (uint amountOut);

    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint deadline;
        uint amountOut;
        uint amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    function exactOutputSingle(
        ExactOutputSingleParams calldata params
    ) external payable returns (uint amountIn);

    struct ExactOutputParams {
        bytes path;
        address recipient;
        uint deadline;
        uint amountOut;
        uint amountInMaximum;
    }

    function exactOutput(
        ExactOutputParams calldata params
    ) external payable returns (uint amountIn);
}


Tasks:
    - Complete the function below
        function swapExactInputSingleHop(uint amountIn, uint amountOutMin) external {}

        This function will swap WETH for maximum amount of DAI.

            - Pull in amountIn amount of WETH from msg.sender into this contract.
            - Approve router to spend amountIn amount of WETH.
        
        Execute the trade by calling the function below

            struct ExactInputSingleParams {
                address tokenIn;
                address tokenOut;
                uint24 fee;
                address recipient;
                uint deadline;
                uint amountIn;
                uint amountOutMinimum;
                uint160 sqrtPriceLimitX96;
            }

            function exactInputSingle(
                ExactInputSingleParams calldata params
            ) external payable returns (uint amountOut);

        - Prepare struct ISwapRouter.ExactInputSingleParams
        
        ISwapRouter.ExactInputSingleParams
                                                                    Input to use
            tokenIn 	        Address of token in	                WETH
            tokenOut	        Address of token out	            DAI
            fee	                Trade fee	                        3000
            recipient	        Recipient of output token	        msg.sender
            deadline	        Deadline (timestamp) of the trade	block.timestamp
            amountIn	        Amount of token in	                amountIn
            amountOutMinimum	Minimum amount of token out	        amountOutMin
            sqrtPriceLimitX96	Limit for the change in price	    0
        
        - Execute the trade by calling router.exactInputSingle with the parameters prepared above


    - Complete the function below
        function swapExactOutputSingleHop(uint amountOut, uint amountInMax) external {}

        This function will swap minimum amount of WETH for a specific amount of DAI.
            - Pull in amountInMax amount of WETH from msg.sender into this contract.
            - Approve router to spend amountInMax amount of WETH.
            
        Execute the trade by calling the function below
            struct ExactOutputSingleParams {
                address tokenIn;
                address tokenOut;
                uint24 fee;
                address recipient;
                uint deadline;
                uint amountOut;
                uint amountInMaximum;
                uint160 sqrtPriceLimitX96;
            }

            function exactOutputSingle(
                ExactOutputSingleParams calldata params
            ) external payable returns (uint amountIn);

        - Prepare struct ISwapRouter.ExactOutputSingleParams
        
        ISwapRouter.ExactOutputSingleParams
        
                                                                                            Input to use
            tokenIn	                    Address of token in	                                WETH
            tokenOut	                Address of token out	                            DAI
            fee	                        Trade fee	                                        3000
            recipient	                Recipient of output token	                        msg.sender
            deadline	                Deadline (timestamp) of the trade	                block.timestamp
            amountOut	                Amount of token out	                                amountOut
            amountInMaximum	            Maximum amount of token in to swap for token out	amountInMax
            sqrtPriceLimitX96	        Limit for the change in price	                    0
            
        - Execute the trade by calling router.exactOutputSingle with the parameters prepared above
          router.exactOutputSingle returns the actual amount of token in swapped for token out.

        - Refund WETH not spent back to msg.sender
        - Reset approvals of WETH for router to 0

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import and use hardhat/console.sol to debug your contract
// import "hardhat/console.sol";

import "./IERC20.sol";
import "./ISwapRouter.sol";

contract UniswapV3SingleHopSwap {
    ISwapRouter private constant router =
        ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    IERC20 private constant weth = IERC20(WETH);
    IERC20 private constant dai = IERC20(DAI);

    function swapExactInputSingleHop(
        uint amountIn,
        uint amountOutMin
    ) external {
        // Code here
    }

    function swapExactOutputSingleHop(
        uint amountOut,
        uint amountInMax
    ) external {
        // Code here
    }
}

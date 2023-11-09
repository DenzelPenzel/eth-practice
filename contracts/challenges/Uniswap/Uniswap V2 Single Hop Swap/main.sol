/*

This challenge introduces 2 functions to swap tokens on Uniswap V2

swapExactTokensForTokens - Sell all of input token.
swapTokensForExactTokens - Buy specific amount of output token.
Here is the interface for Uniswap V2 router.

interface IUniswapV2Router {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}


Tasks:
    - Complete swapSingleHopExactAmountIn
        function swapSingleHopExactAmountIn(
            uint amountIn,
            uint amountOutMin
        ) external {}

        This function will call swapExactTokensForTokens on Uniswap V2 router to swap all of WETH for DAI.

        - Transfer amountIn amount of WETH from msg.sender
        - Approve Uniswap V2 router, router to pull amountIn amount of WETH from this contract.
        - Initialize memory array of addresses having length 2, path. This will instruct Uniswap on what tokens to trade.
        - Set path[0] to WETH. This is the token that we're selling.
        - Set path[1] to DAI. This is the token that we're buying.
        - Call swapExactTokensForTokens on router to execute the trade.
            function swapExactTokensForTokens(
                uint amountIn,
                uint amountOutMin,
                address[] calldata path,
                address to,
                uint deadline
            ) external returns (uint[] memory amounts);

        Inputs
                                                                                             Input to use
            amountIn	       Amount of input token to sell	                             amountIn
            amountOutMin	   Minimum amount of output token to receive from the trade	     amountOutMin
            path	           Array of token addresses, specifies which tokens to trade.	 path
            to	               Recipient of output token	                                 msg.sender
            deadline	       Deadline (timestamp) of the trade	                         block.timestamp
            
        Outputs
            amounts	           Input token amount and subsequent ouput token amounts
        
        Outputs are not used in this task.



- Complete swapSingleHopExactAmountOut
    function swapSingleHopExactAmountOut(
        uint amountOutDesired,
        uint amountInMax
    ) external {}

    This function will call swapTokensForExactTokens on Uniswap V2 router 
    to swap at most amountInMax of WETH until the target amount, amountOUtDesired amount of DAI is obtained.

    - Transfer amountInMax amount of WETH from msg.sender
    - Approve Uniswap V2 router, router to pull amountInMax amount of WETH from this contract.
    - Initialize memory array of addresses having length 2, path. This will instruct Uniswap on what tokens to trade.
    - Set path[0] to WETH. This is the token that we're selling.
    - Set path[1] to DAI. This is the token that we're buying.
    - Call swapTokensForExactTokens on router to execute the trade.
        function swapTokensForExactTokens(
            uint amountOut,
            uint amountInMax,
            address[] calldata path,
            address to,
            uint deadline
        ) external returns (uint[] memory amounts);

    Inputs
                                                                                Input to use

        amountOut	Amount of output token to receive	                        amountOutDesired
        amountInMax	Maximum amount of input token to sell	                    amountInMax
        path	    Array of token addresses, specifies which tokens to trade.	path
        to	        Recipient of output token	                                msg.sender
        deadline	Deadline (timestamp) of the trade	                        block.timestamp

    Outputs

        amounts	Input token amount and subsequent ouput token amounts
        
        - Refund excess WETH to msg.sender. Amount of WETH spent by Uniswap is stored in amounts[0].


*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import and use hardhat/console.sol to debug your contract
// import "hardhat/console.sol";

import "./IERC20.sol";
import "./IUniswapV2Router.sol";

contract UniswapV2SingleHopSwap {
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    IUniswapV2Router private constant router =
        IUniswapV2Router(UNISWAP_V2_ROUTER);
    IERC20 private constant weth = IERC20(WETH);
    IERC20 private constant dai = IERC20(DAI);

    function swapSingleHopExactAmountIn(
        uint amountIn,
        uint amountOutMin
    ) external {
        // Code
    }

    function swapSingleHopExactAmountOut(
        uint amountOutDesired,
        uint amountInMax
    ) external {
        // Code
    }
}

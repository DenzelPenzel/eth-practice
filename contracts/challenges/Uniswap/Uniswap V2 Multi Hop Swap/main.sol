/*

Sell DAI and buy CRV.

However there is no DAI - CRV pool, so we will execute multi hop swaps, DAI to WETH and then WETH to CRV.


Tasks:
    - Complete the function
        function swapMultiHopExactAmountIn(uint amountIn, uint amountOutMin) external {}

        This function will swap all of DAI for maximum amount of CRV. 
        It will execute multi hop swaps from DAI to WETH and then WETH to CRV.

            - Transfer amountIn DAI from msg.sender into the contract
            - Approve the router to spend amountIn DAI from the contract
            - Setup the swapping path. This is an array of addresses, DAI, WETH and CRV.
            - Call the function swapExactTokensForTokens on router. Below is the function to call.
            - Send CRV to msg.sender
        
        function swapExactTokensForTokens(
            uint amountIn,
            uint amountOutMin,
            address[] calldata path,
            address to,
            uint deadline
        ) external returns (uint[] memory amounts);


    - Complete the function
        function swapMultiHopExactAmountOut(
            uint amountOutDesired,
            uint amountInMax
        ) external {}

        This function will swap minimum DAI to obtain a specific amount of CRV. 
        It will execute multi hop swaps from DAI to WETH and then WETH to CRV.

        - Transfer amountInMax DAI from msg.sender into the contract
        - Approve the router to spend amountInMax DAI from the contract
        - Setup the swapping path. This is an array of addresses, DAI, WETH and CRV.
        - Call the function swapTokensForExactTokens on router. Below is the function to call.
        - Send CRV to msg.sender
        
        function swapTokensForExactTokens(
            uint amountOut,
            uint amountInMax,
            address[] calldata path,
            address to,
            uint deadline
        ) external returns (uint[] memory amounts);

        - Refund DAI to msg.sender if not all of DAI was spent. 
          swapTokensForExactTokens returns an array of uint, amounts. 
          Amount of DAI spent is stored in amounts[0].
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import and use hardhat/console.sol to debug your contract
// import "hardhat/console.sol";

import "./IERC20.sol";
import "./IUniswapV2Router.sol";

contract UniswapV2MultiHopSwap {
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant CRV = 0xD533a949740bb3306d119CC777fa900bA034cd52;

    IUniswapV2Router private constant router =
        IUniswapV2Router(UNISWAP_V2_ROUTER);
    IERC20 private constant weth = IERC20(WETH);
    IERC20 private constant dai = IERC20(DAI);
    IERC20 private constant crv = IERC20(CRV);

    function swapMultiHopExactAmountIn(
        uint amountIn,
        uint amountOutMin
    ) external {
        // Code
    }

    function swapMultiHopExactAmountOut(
        uint amountOutDesired,
        uint amountInMax
    ) external {
        // Code
    }
}

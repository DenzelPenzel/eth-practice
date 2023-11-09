/*

Deposit your tokens into an Uniswap V2 pool to earn trading fees.

This is called adding liquidity.

Remove liquidity to withdraw your tokens and claim your trading fees.


Tasks: 
    - Complete the function
        function addLiquidity(uint wethAmountDesired, uint daiAmountDesired) external {}

        This function adds liquidity to the Uniswap WETH - DAI pool.
            - Transfer wethAmountDesired WETH from msg.sender into the contract
            - Transfer daiAmountDesired DAI from msg.sender into the contract
            - Approve router to spend wethAmountDesired WETH and daiAmountDesired DAI
            - Add liquidity to Uniswap pool by calling addLiquidity on router. Below is an explanation of the function.
            
            function addLiquidity(
                address tokenA,
                address tokenB,
                uint amountADesired,
                uint amountBDesired,
                uint amountAMin,
                uint amountBMin,
                address to,
                uint deadline
            ) external returns (uint amountA, uint amountB, uint liquidity);

        Inputs
                                                                                Input to use
            tokenA	         Address of token A	                                WETH
            tokenB	         Address of token B	                                DAI
            amountADesired	 Desired amount of token A to provide as liquidity	wethAmountDesired
            amountBDesired	 Desired amount of token B to provide as liquidity	daiAmountDesired
            amountAMin	     Minimum amount ot token A that must be added	    1
            amountBMin	     Minimum amount of token B that must be added	    1
            to	             Recipient of the liquidity tokens	                msg.sender
            deadline	     Deadline (timestamp) of the transaction	        block.timestamp
            
        Outputs

            amountA	    Amount of token A added as liquidity to the pool
            amountB	    Amount of token B added as liquidity to the pool
            liquidity	Amount of liquidity tokens minted
            
            - Refund to msg.sender, excess WETH and DAI that were not added to liquidity. 
              Amount added to pool is stored in the outputs amountA and amountB.


    - Complete the function
        function removeLiquidity(uint liquidity) external {}

        This function removes liquidity from the Uniswap WETH - DAI pool.
            - Transfer liquidity amount of liquidity tokens from msg.sender into the contract by calling pair.transferFrom.
            - Approve router to spend liquidity amount ot liquidity tokens
            - Remove liquidity from Uniswap pool by calling removeLiquidity on router. Below is an explanation of the function.
            
            function removeLiquidity(
                address tokenA,
                address tokenB,
                uint liquidity,
                uint amountAMin,
                uint amountBMin,
                address to,
                uint deadline
            ) external returns (uint amountA, uint amountB);

        Inputs    
            Input to use
            tokenA	     Address of token A	                                WETH
            tokenB	     Address of token B	                                DAI
            liquidity	 Amount of liquidity tokens to burn	                liquidity
            amountAMin	 Minimum amount ot token A that must be withdrawn	1
            amountBMin	 Minimum amount of token B that must be withdrawn	1
            to	         Recipient of token A and token B	                msg.sender
            deadline	 Deadline (timestamp) of the transaction	        block.timestamp
        
        Outputs
            amountA	Amount of token A removed from the pool
            amountB	Amount of token B remove from the pool
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import and use hardhat/console.sol to debug your contract
// import "hardhat/console.sol";

import "./IERC20.sol";
import "./IUniswapV2Router.sol";
import "./IUniswapV2Factory.sol";

contract UniswapV2Liquidity {
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    address private constant UNISWAP_V2_FACTORY =
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;

    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    IUniswapV2Router private constant router =
        IUniswapV2Router(UNISWAP_V2_ROUTER);
    IUniswapV2Factory private constant factory =
        IUniswapV2Factory(UNISWAP_V2_FACTORY);

    IERC20 private constant weth = IERC20(WETH);
    IERC20 private constant dai = IERC20(DAI);

    IERC20 private immutable pair;

    constructor() {
        pair = IERC20(factory.getPair(WETH, DAI));
    }

    function addLiquidity(
        uint wethAmountDesired,
        uint daiAmountDesired
    ) external {
        // Code
    }

    function removeLiquidity(uint liquidity) external {
        // Code
    }
}

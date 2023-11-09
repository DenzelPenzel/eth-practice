/*

Tokens in the pool can be borrowed as long as they are repaid in the same transaction plus fee on borrow.

This is called flash swap.


Tasks:
    - Complete
        function flashSwap(uint wethAmount) external {}

        This function initiates the flash swap, borrowing wethAmount of WETH.

            - Prepare data of bytes to send. This can be any data, as long as 
              it is not empty Uniswap will trigger a flash swap. For this challenge, encode WETH and msg.sender.
        
        bytes memory data = abi.encode(WETH, msg.sender);

            - Call the function swap on pair to initiate the flash swap.

            function swap(
                uint amount0Out,
                uint amount1Out,
                address to,
                bytes calldata data
            ) external;

        Inputs                                                                     Input to use
            amount0Out	Amount of token0 to withdraw from the pool	 0
            amount1Out	Amount of token1 to withdraw from the pool	 wethAmount
            to	        Recipient of tokens in the pool	             address(this)
            data	    Data to send to uniswapV2Call	             data

    
    - Complete the function
        function uniswapV2Call(
            address sender,
            uint amount0,
            uint amount1,
            bytes calldata data
        ) external {}

        This function is call by Uniswap pool after we called pair.swap.

        Immediately before the pool calls this function, the amount of tokens that we requested to
        borrow is sent. Inside this function, we write our custom code and then repay the borrowed amount plus some fees.

            - Require that msg.sender is pair. Only pair contract should be able to call this function.

            - Require sender is this contract. Initiator of the flash swap should be this contract.

            - Decode data. Inside flashSwap we've encoded WETH and msg.sender.    
                (address tokenBorrow, address caller) = abi.decode(
                    data,
                    (address, address)
                );

            - Once the data is decoded, we would write our custom code here. For example,
                require(tokenBorrow == WETH, "token borrow != WETH");

            - Calculate total amount to repay
                // about 0.3% fee, +1 to round up
                uint fee = ((amount1 * 3) / 997) + 1;
                uint amountToRepay = amount1 + fee;

            - Transfer fee amount of WETH from caller
            
            - Repay WETH to pair, amount borrowed plus fee.
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import and use hardhat/console.sol to debug your contract
// import "hardhat/console.sol";

import "./IERC20.sol";
import "./IUniswapV2Factory.sol";
import "./IUniswapV2Callee.sol";
import "./IUniswapV2Pair.sol";

contract UniswapV2FlashSwap is IUniswapV2Callee {
    address private constant UNISWAP_V2_FACTORY =
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;

    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IUniswapV2Factory private constant factory =
        IUniswapV2Factory(UNISWAP_V2_FACTORY);

    IERC20 private constant weth = IERC20(WETH);

    IUniswapV2Pair private immutable pair;

    constructor() {
        pair = IUniswapV2Pair(factory.getPair(DAI, WETH));
    }

    function flashSwap(uint wethAmount) external {
        // Code
    }

    // This function is called by the DAI/WETH pair contract
    function uniswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external {
        // Code
    }
}

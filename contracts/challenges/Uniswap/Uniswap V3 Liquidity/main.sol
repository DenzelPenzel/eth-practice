/*

Manage liquidity in Uniswap V3
    - Mint new position
    - Increase liquidity
    - Decrease liquidity
    - Collect fees and withdraw tokens

    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.20;

    interface INonfungiblePositionManager {
        function positions(
            uint tokenId
        )
            external
            view
            returns (
                uint96 nonce,
                address operator,
                address token0,
                address token1,
                uint24 fee,
                int24 tickLower,
                int24 tickUpper,
                uint128 liquidity,
                uint feeGrowthInside0LastX128,
                uint feeGrowthInside1LastX128,
                uint128 tokensOwed0,
                uint128 tokensOwed1
            );

        struct MintParams {
            address token0;
            address token1;
            uint24 fee;
            int24 tickLower;
            int24 tickUpper;
            uint amount0Desired;
            uint amount1Desired;
            uint amount0Min;
            uint amount1Min;
            address recipient;
            uint deadline;
        }

        function mint(
            MintParams calldata params
        )
            external
            payable
            returns (uint tokenId, uint128 liquidity, uint amount0, uint amount1);

        struct IncreaseLiquidityParams {
            uint tokenId;
            uint amount0Desired;
            uint amount1Desired;
            uint amount0Min;
            uint amount1Min;
            uint deadline;
        }

        function increaseLiquidity(
            IncreaseLiquidityParams calldata params
        ) external payable returns (uint128 liquidity, uint amount0, uint amount1);

        struct DecreaseLiquidityParams {
            uint tokenId;
            uint128 liquidity;
            uint amount0Min;
            uint amount1Min;
            uint deadline;
        }

        function decreaseLiquidity(
            DecreaseLiquidityParams calldata params
        ) external payable returns (uint amount0, uint amount1);

        struct CollectParams {
            uint tokenId;
            address recipient;
            uint128 amount0Max;
            uint128 amount1Max;
        }

        function collect(
            CollectParams calldata params
        ) external payable returns (uint amount0, uint amount1);

        function ownerOf(uint tokenId) external view returns (address owner);
    }

Tasks:
    - Complete the function onERC721Received
        function onERC721Received(
            address operator,
            address from,
            uint tokenId,
            bytes calldata
        ) external returns (bytes4) {}

        This function is called when safeTransferFrom is called on INonFungiblePositionManager.

        Return IERC721Receiver.onERC721Received.selector


    - Mint new position
        Complete the function below
            function mint(uint amount0ToAdd, uint amount1ToAdd) external {}

    - Transfer tokens
        - Transfer DAI and WETH from msg.sender into this contract. amount0ToAdd is DAI amount, amount1ToAdd is WETH
        - Approve manager to spend DAI and WETH from this contract
        
    Add liquidity
        struct MintParams {
            address token0;
            address token1;
            uint24 fee;
            int24 tickLower;
            int24 tickUpper;
            uint amount0Desired;
            uint amount1Desired;
            uint amount0Min;
            uint amount1Min;
            address recipient;
            uint deadline;
        }

        function mint(
            MintParams calldata params
        )
            external
            payable
            returns (uint tokenId, uint128 liquidity, uint amount0, uint amount1);

        - Set tickLower and tickUpper, price range to add liquidity
        
        Both ticks must be a multiple of TICK_SPACING.
            int24 tickLower = (MIN_TICK / TICK_SPACING) * TICK_SPACING;
            int24 tickUpper = (MAX_TICK / TICK_SPACING) * TICK_SPACING;

        - Prepare parameter to add new liquidity and mint new position
        
        INonfungiblePositionManager.MintParams
                                                                                Input to use
        token0	                Token 0	                                        DAI
        token1	                Token 1	                                        WETH
        fee	                    Pool fee	                                    3000
        tickLower	            Lower price	                                    tickLower
        tickUpper	            Upper price	                                    tickUpper
        amount0Desired	        Amount of token 0 to add	                    amount0ToAdd
        amount1Desired	        Amount of token 1 to add	                    amount1ToAdd
        amount0Min	            Minimum amount of token 0 that must be added	0
        amount1Min	            Minimum amount of token 1 that must be added	0
        recipient	            Recipient of newly minted ERC721	            address(this)
        deadline	            Deadline (timestamp) of the transaction	        block.timestamp
        
        - Add liquidity by calling manager.mint with the parameters prepared above
        
    - Refund
        manager.mint returns 4 outputs
            function mint(
                MintParams calldata params
            )
                external
                payable
                returns (uint tokenId, uint128 liquidity, uint amount0, uint amount1);

        tokenId	    Newly minted ERC721 token id
        liquidity	Amount of liquidity added
        amount0	    Amount of token 0 added
        amount1	    Amount of token 1 added
        
        - Refund tokens not added to liquidity back to msg.sender. We pulled in amount0ToAdd and amount1ToAdd. 
          Actual amount added to Uniswap V3 are amount0 and amount1
        
        - Reset approvals of DAI and WETH for manager to 0
        
    Event
        - Emit Mint with tokenId.

    - Increase liquidity for current position
        Complete the function below

        function increaseLiquidity(
            uint tokenId,
            uint amount0ToAdd,
            uint amount1ToAdd
        ) external {}

        
    - Transfer tokens
        - Transfer DAI and WETH from msg.sender into this contract. amount0ToAdd is DAI amount, amount1ToAdd is WETH
        - Approve manager to spend DAI and WETH from this contract

    - Increase liquidity
        struct IncreaseLiquidityParams {
            uint tokenId;
            uint amount0Desired;
            uint amount1Desired;
            uint amount0Min;
            uint amount1Min;
            uint deadline;
        }

        function increaseLiquidity(
            IncreaseLiquidityParams calldata params
        ) external payable returns (uint128 liquidity, uint amount0, uint amount1);

    
        - Prepare parameter to increase liquidity

        INonfungiblePositionManager.IncreaseLiquidityParams
                                                                                        Input to use
        tokenId	                        ERC721 token id	                                tokenId
        amount0Desired	                Amount of token 0 to add	                    amount0ToAdd
        amount1Desired	                Amount of token 1 to add	                    amount1ToAdd
        amount0Min	                    Minimum amount of token 0 that must be added	0
        amount1Min	                    Minimum amount of token 1 that must be added	0
        deadline	                    Deadline (timestamp) of the transaction	        block.timestamp
        
        - Increase liquidity by calling manager.increaseLiquidity with the parameters prepared above

    - Refund
        manager.increaseLiquidity returns 3 outputs

        function increaseLiquidity(
            IncreaseLiquidityParams calldata params
        ) external payable returns (uint128 liquidity, uint amount0, uint amount1);

        liquidity	Amount of liquidity added
        amount0	Amount of token 0 added
        amount1	Amount of token 1 added

        - Refund tokens not added to liquidity back to msg.sender. We pulled in 
          amount0ToAdd and amount1ToAdd. Actual amount added to Uniswap V3 are amount0 and amount1
        - Reset approvals of DAI and WETH for manager to 0

    - Decrease liquidity for current position
        Complete the function below
            function decreaseLiquidity(uint tokenId, uint128 liquidity) external {}

    - Decrease liquidity
        struct DecreaseLiquidityParams {
            uint tokenId;
            uint128 liquidity;
            uint amount0Min;
            uint amount1Min;
            uint deadline;
        }

        function decreaseLiquidity(
            DecreaseLiquidityParams calldata params
        ) external payable returns (uint amount0, uint amount1);

        - Prepare parameter to decrease liquidity
    
        INonfungiblePositionManager.DecreaseLiquidityParams
                                                                        Input to use
        tokenId	    ERC721 token id	tokenId
        liquidity	Amount of liquidity to decrease	                    liquidity
        amount0Min	Minimum amount of token 0 that must be withdrawn	0
        amount1Min	Minimum amount of token 1 that must be withdrawn	0
        deadline	Deadline (timestamp) of the transaction	            block.timestamp

        - Decrease liquidity by calling manager.decreaseLiquidity with the parameters prepared above


    - Collect fees and withdraw liquidity
        manager.collect is called to collect fees and withdraw liquidity.

        Here it will be used to withdraw liquidity.

        Complete the function below.
            function collect(uint tokenId) external {}

    -Withdraw liquidity
        struct CollectParams {
            uint tokenId;
            address recipient;
            uint128 amount0Max;
            uint128 amount1Max;
        }

        function collect(
            CollectParams calldata params
        ) external payable returns (uint amount0, uint amount1);

        - Prepare parameter to withdraw liquidity
        
        INonfungiblePositionManager.CollectParams
                                                                        Input to use
        tokenId	    ERC721 token id	                                    tokenId
        recipient	Recipient of token 0 and token 1	                msg.sender
        amount0Max	Minimum amount of token 0 that must be withdrawn	type(uint128).max
        amount1Max	Minimum amount of token 1 that must be withdrawn	type(uint128).max

        - Withdraw liquidity by calling manager.collect with the parameters prepared above

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";
import "./IERC721Receiver.sol";
import "./INonfungiblePositionManager.sol";

contract UniswapV3Liquidity is IERC721Receiver {
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IERC20 private constant dai = IERC20(DAI);
    IERC20 private constant weth = IERC20(WETH);

    int24 private constant MIN_TICK = -887272;
    int24 private constant MAX_TICK = -MIN_TICK;
    int24 private constant TICK_SPACING = 60;

    INonfungiblePositionManager public manager =
        INonfungiblePositionManager(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);

    event Mint(uint tokenId);

    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata
    ) external returns (bytes4) {
        // Code
    }

    function mint(uint amount0ToAdd, uint amount1ToAdd) external {
        // Code
    }

    function increaseLiquidity(
        uint tokenId,
        uint amount0ToAdd,
        uint amount1ToAdd
    ) external {
        // Code
    }

    function decreaseLiquidity(uint tokenId, uint128 liquidity) external {
        // Code
    }

    function collect(uint tokenId) external {
        // Code
    }
}

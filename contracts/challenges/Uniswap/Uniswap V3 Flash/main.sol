/*
Borrow tokens from Uniswap V3 pool and then repay with fee in a single transaction. This is called flash loan.

Call flash on Uniswap V3 pool to borrow WETH.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IUniswapV3Pool {
    function flash(
        address recipient,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external;
}

Tasks:
    - Initialize the variable pool.
        The variable pool is immutable, so initialize it inside the constructor.

        Address of the pool can be obtained by calling PoolAddress.computeAddress.

            function computeAddress(
                address factory,
                PoolKey memory key
            ) internal pure returns (address pool) {}

        PoolKey can be obtained by calling PoolAddress.getPoolKey. Get the PoolKey for DAI / WETH pool with 0.3% fee (3000).

        Here is the full code for PoolAddress.sol.
            // SPDX-License-Identifier: GPL-2.0-or-later
            pragma solidity ^0.8.20;

            library PoolAddress {
                bytes32 internal constant POOL_INIT_CODE_HASH =
                    0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;

                struct PoolKey {
                    address token0;
                    address token1;
                    uint24 fee;
                }

                function getPoolKey(
                    address tokenA,
                    address tokenB,
                function computeAddress(
                    address factory,
                    PoolKey memory key
                ) interna        uint24 fee
                ) internal pure returns (PoolKey memory) {
                    if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
                    return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
                }

                function computeAddress(
                    address factory,
                    PoolKey memory key
                ) internal pure returns (address pool) {
                    require(key.token0 < key.token1);
                    pool = address(
                        uint160(
                            uint(
                                keccak256(
                                    abi.encodePacked(
                                        hex"ff",
                                        factory,
                                        keccak256(
                                            abi.encode(key.token0, key.token1, key.fee)
                                        ),
                                        POOL_INIT_CODE_HASH
                                    )
                                )
                            )
                        )
                    );
                }
            }


    - Complete the function flash.
        function flash(uint wethAmount) external {
            // Code
        }

        Overview
            This function will initialize the flash loan on Uniswap V3 pool by calling pool.flash

            Below is an overview of what will happen after pool.flash is called.

            - The pool sends tokens to the borrower.
            - The pool calls uniswapV3FlashCallback on the borrower.
            - Inside the uniswapV3FlashCallback our custom code is executed. 
              At the end of the code, we must pay back the borrowed amount plus fees.

        Call pool.flash
            - Prepare data to be passed to pool.flash. Any bytes can be passed, but for this challenge we will encode our custom struct FlashData.   
                bytes memory data = abi.encode(
                    FlashData({wethAmount: wethAmount, caller: msg.sender})
                );

            - Call pool.flash
                interface IUniswapV3Pool {
                    function flash(
                        address recipient,
                        uint amount0,
                        uint amount1,
                        bytes calldata data
                    ) external;
                }

                                                                     Input to use
        recipient	Recipient of tokens to borrow	                 address(this)
        amount0	    Amount of token 0 to borrow	                     0
        amount1	    Amount of token 1 to borrow	                     wethAmount
        data	    Any data to be passed to uniswapV3FlashCallback	 data


    - Complete the function
        function uniswapV3FlashCallback(
            uint fee0,
            uint fee1,
            bytes calldata data
        ) external {}

        This is the function called by pool, after we call pool.flash.

        Here we have the requested borrow amount of WETH. Our custom code logic goes here. 
        For this challenge, we will simply repay the borrowed amount plus fee.
            - Require that msg.sender is the pool. Set the error message to "not authorized".
            - Decode the data into FlashData

        FlashData memory decoded = abi.decode(data, (FlashData));
            - Caller stored in FlashData will pay for the fee on borrow. 
              Transfer WETH from decoded.caller into this contract for the amount fee1.
            - Repay WETH back to the pool. Transfer borrowed amount + fee1.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";
import "./IUniswapV3Pool.sol";
import "./PoolAddress.sol";

contract UniswapV3Flash {
    address private constant FACTORY =
        0x1F98431c8aD98523631AE4a59f267346ea31F984;

    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IERC20 private constant weth = IERC20(WETH);

    uint24 private constant POOL_FEE = 3000;

    struct FlashData {
        uint wethAmount;
        address caller;
    }

    IUniswapV3Pool private immutable pool;

    constructor() {
        // Code
    }

    function flash(uint wethAmount) external {
        // Code
    }

    function uniswapV3FlashCallback(
        uint fee0,
        uint fee1,
        bytes calldata data
    ) external {
        // Code
    }
}

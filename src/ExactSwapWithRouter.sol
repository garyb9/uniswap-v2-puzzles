// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IERC20.sol";

contract ExactSwapWithRouter {
    /**
     *  PERFORM AN EXACT SWAP WITH ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap an exact amount of WETH for 1337 USDC token using UniswapV2 router.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function performExactSwapWithRouter(address weth, address usdc, uint256 deadline) public {
        // your code start here

        IUniswapV2Router routerInterface = IUniswapV2Router(router);
        uint256 usdcAmount = 1337e6;
        uint256 wethBalance = IERC20(weth).balanceOf(address(this));

        address[] memory path = new address[](2);
        path[0] = weth; // tokenIn;
        path[1] = usdc; // tokenOut;

        IERC20(weth).approve(router, wethBalance);
        routerInterface.swapExactTokensForTokens(wethBalance, usdcAmount, path, address(this), deadline);

        uint256 usdcBalance = IERC20(usdc).balanceOf(address(this));

        address[] memory path2 = new address[](2);
        path2[0] = usdc; // tokenIn;
        path2[1] = weth; // tokenOut;

        IERC20(usdc).approve(router, usdcBalance - usdcAmount);
        IUniswapV2Router(router).swapExactTokensForTokens(usdcBalance - usdcAmount, 1, path2, address(this), deadline);
    }
}

interface IUniswapV2Router {
    /**
     *     amountIn: the amount of input tokens to swap.
     *     amountOutMin: the minimum amount of output tokens that must be received for the transaction not to revert.
     *     path: an array of token addresses. In our case, WETH and USDC.
     *     to: recipient address to receive the liquidity tokens.
     *     deadline: timestamp after which the transaction will revert.
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

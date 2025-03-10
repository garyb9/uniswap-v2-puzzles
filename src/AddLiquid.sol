// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract AddLiquid {
    /**
     *  ADD LIQUIDITY WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1000 USDC and 1 WETH.
     *  Mint a position (deposit liquidity) in the pool USDC/WETH to msg.sender.
     *  The challenge is to provide the same ratio as the pool then call the mint function in the pool contract.
     *
     */
    function balanceOfToken(address token) internal view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    function sendTokens(address token, address recipient, uint256 amount) internal {
        IERC20(token).transfer(recipient, amount);
    }

    function addLiquidity(address usdc, address weth, address pool, uint256 usdcReserve, uint256 wethReserve) public {
        IUniswapV2Pair pair = IUniswapV2Pair(pool);

        uint256 usdcBalance = balanceOfToken(usdc);
        uint256 wethBalance = balanceOfToken(weth);

        uint256 usdcRatio = usdcBalance / usdcReserve;
        uint256 wethRatio = wethBalance / wethReserve;

        if (usdcRatio < wethRatio) {
            sendTokens(usdc, pool, usdcBalance);
            sendTokens(weth, pool, wethBalance * wethReserve / usdcReserve);
        } else {
            sendTokens(weth, pool, wethBalance);
            sendTokens(usdc, pool, usdcBalance * usdcReserve / wethReserve);
        }

        pair.mint(msg.sender);
    }
}

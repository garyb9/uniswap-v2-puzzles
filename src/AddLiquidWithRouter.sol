// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import {IERC20} from "./interfaces/IERC20.sol";

contract AddLiquidWithRouter {
    /**
     *  ADD LIQUIDITY WITH ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1000 USDC and 1 ETH.
     *  Mint a position (deposit liquidity) in the pool USDC/ETH to `msg.sender`.
     *  The challenge is to use Uniswapv2 router to add liquidity to the pool.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function balanceOfToken(address token) internal view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    function addLiquidityWithRouter(address usdcAddress, uint256 deadline) public {
        IUniswapV2Router routerInterface = IUniswapV2Router(router);
        uint256 usdcBalance = balanceOfToken(usdcAddress);
        uint256 ethBalance = address(this).balance;

        routerInterface.addLiquidityETH(usdcAddress, usdcBalance, usdcBalance, ethBalance, msg.sender, deadline);
    }

    receive() external payable {}
}

interface IUniswapV2Router {
    /**
     *     token: the usdc address
     *     amountTokenDesired: the amount of USDC to add as liquidity.
     *     amountTokenMin: bounds the extent to which the ETH/USDC price can go up before the transaction reverts. Must be <= amountUSDCDesired.
     *     amountETHMin: bounds the extent to which the USDC/ETH price can go up before the transaction reverts. Must be <= amountETHDesired.
     *     to: recipient address to receive the liquidity tokens.
     *     deadline: timestamp after which the transaction will revert.
     */
    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
}

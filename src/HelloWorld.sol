// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IERC20.sol";

contract HelloWorld {
    /**
     *  HELLO WORLD EXERCISE
     *
     *  The contract returns Hello World string.
     *
     */
    function sayHelloWorld() public pure returns (string memory) {
        return "Hello World";
    }
}

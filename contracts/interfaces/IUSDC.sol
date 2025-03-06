// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IUSDC
 * @dev Interface for USDC token with basic ERC20 functions
 */
interface IUSDC {
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

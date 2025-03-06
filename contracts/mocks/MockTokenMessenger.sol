// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/ICCTPTokenMessenger.sol";
import "../interfaces/IUSDC.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MockTokenMessenger
 * @dev A mock implementation of Circle's TokenMessenger for testing purposes
 */
contract MockTokenMessenger is Ownable {
    // Event to track depositForBurn calls
    event DepositForBurn(
        uint256 amount,
        uint32 destinationDomain,
        bytes32 mintRecipient,
        address burnToken
    );
    
    // Counter for message nonces
    uint64 private _nonce = 0;
    
    constructor() Ownable(msg.sender) {}
    
    /**
     * @notice Mock implementation of depositForBurn
     * @param amount Amount of tokens to burn
     * @param destinationDomain Destination domain
     * @param mintRecipient Address of the mint recipient on the destination domain
     * @param burnToken Address of the token to burn
     * @return nonce The nonce for the message
     */
    function depositForBurn(
        uint256 amount,
        uint32 destinationDomain,
        bytes32 mintRecipient,
        address burnToken
    ) external returns (uint64 nonce) {
        // Increment nonce
        _nonce++;
        
        // Transfer tokens from sender to this contract (simulating burning)
        IUSDC(burnToken).transferFrom(msg.sender, address(this), amount);
        
        // Emit event
        emit DepositForBurn(amount, destinationDomain, mintRecipient, burnToken);
        
        return _nonce;
    }
    
    /**
     * @dev Helper function to simulate message receiving on destination chain
     * @param token The token to mint
     * @param to The recipient
     * @param amount The amount to mint
     */
    function simulateMessageReceived(
        address token,
        address to,
        uint256 amount
    ) external onlyOwner {
        // This would be a mint operation in a real implementation
        // Here we just transfer the tokens we have
        IUSDC(token).transfer(to, amount);
    }
} 
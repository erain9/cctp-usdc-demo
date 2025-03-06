// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ICCTPTokenMessenger
 * @dev Interface for Circle's CCTP TokenMessenger contract
 */
interface ICCTPTokenMessenger {
    /**
     * @notice Burns tokens and emits a message to the destination domain.
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
    ) external returns (uint64 nonce);
} 
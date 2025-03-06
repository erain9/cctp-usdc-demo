// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/ICCTPTokenMessenger.sol";
import "./interfaces/IUSDC.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title CCTPBridge
 * @dev A contract to demonstrate USDC transfers via Circle's Cross-Chain Transfer Protocol
 */
contract CCTPBridge is Ownable {
    ICCTPTokenMessenger public tokenMessenger;
    IUSDC public usdcToken;
    
    event USDCBridged(address indexed from, uint32 destinationDomain, address destinationReceiver, uint256 amount);
    
    /**
     * @dev Constructor
     * @param _tokenMessenger Address of Circle's TokenMessenger contract
     * @param _usdcToken Address of the USDC token contract
     */
    constructor(address _tokenMessenger, address _usdcToken) Ownable(msg.sender) {
        tokenMessenger = ICCTPTokenMessenger(_tokenMessenger);
        usdcToken = IUSDC(_usdcToken);
    }
    
    /**
     * @dev Bridge USDC to another chain
     * @param destinationDomain The destination domain (chain identifier in CCTP)
     * @param destinationReceiver The receiving address on the destination chain
     * @param amount The amount of USDC to bridge
     */
    function bridgeUSDC(uint32 destinationDomain, bytes32 destinationReceiver, uint256 amount) external {
        // Transfer USDC from sender to this contract
        usdcToken.transferFrom(msg.sender, address(this), amount);
        
        // Approve CCTP TokenMessenger to spend USDC
        usdcToken.approve(address(tokenMessenger), amount);
        
        // Initiate the cross-chain transfer
        tokenMessenger.depositForBurn(amount, destinationDomain, destinationReceiver, address(usdcToken));
        
        emit USDCBridged(msg.sender, destinationDomain, address(uint160(uint256(destinationReceiver))), amount);
    }
    
    /**
     * @dev Allows owner to rescue any ERC20 tokens accidentally sent to the contract
     * @param token Address of the token to rescue
     * @param to Address to send the tokens to
     * @param amount Amount of tokens to rescue
     */
    function rescueTokens(address token, address to, uint256 amount) external onlyOwner {
        IUSDC(token).transfer(to, amount);
    }
} 
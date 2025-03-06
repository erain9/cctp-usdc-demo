# CCTP USDC Bridge: Complete Project Documentation

## Table of Contents

1. [Introduction](#introduction)
2. [Project Overview](#project-overview)
3. [Technical Architecture](#technical-architecture)
4. [Circle's Cross-Chain Transfer Protocol (CCTP)](#circles-cross-chain-transfer-protocol-cctp)
5. [Smart Contract Documentation](#smart-contract-documentation)
6. [Setup and Installation](#setup-and-installation)
7. [Usage Guide](#usage-guide)
8. [Deployment Instructions](#deployment-instructions)
9. [Troubleshooting](#troubleshooting)
10. [Security Considerations](#security-considerations)
11. [Resources and References](#resources-and-references)

## Introduction

This documentation provides a comprehensive guide to the CCTP USDC Bridge project, which demonstrates how to use Circle's Cross-Chain Transfer Protocol (CCTP) to transfer USDC between different blockchain networks. The project includes smart contracts, deployment scripts, and tests that showcase secure and efficient USDC transfers across supported chains.

## Project Overview

### Purpose

The CCTP USDC Bridge project serves as a practical implementation and reference for developers looking to integrate Circle's Cross-Chain Transfer Protocol into their applications. By providing a complete working example, this project aims to simplify the process of implementing cross-chain USDC transfers.

### Key Features

- Smart contract for bridging USDC between supported blockchains
- Deployment scripts for various testnets and mainnets
- Comprehensive test suite using mock contracts
- TypeScript support for better type safety and developer experience
- Makefile for simplified common operations

### Supported Chains

The project supports all blockchains that are compatible with Circle's CCTP, including:

- Ethereum
- Arbitrum
- Avalanche
- Optimism
- Base
- Solana (through external integrations)

## Technical Architecture

### High-Level Architecture

The CCTP USDC Bridge consists of several components working together:

1. **CCTPBridge Contract**: The main smart contract that interacts with Circle's TokenMessenger to facilitate USDC transfers between chains.
2. **Circle's CCTP Contracts**: External contracts (TokenMessenger) that handle the actual burning and minting of USDC tokens.
3. **USDC Token Contracts**: The native USDC token contracts on each chain.
4. **Deployment Scripts**: Scripts to deploy the bridge contract to various networks.
5. **Bridge Operation Scripts**: Scripts that demonstrate how to bridge USDC using the deployed contracts.

### Component Interaction Flow

```
User -> CCTPBridge -> Circle TokenMessenger (source chain) -> Circle TokenMessenger (destination chain) -> User's Wallet (destination chain)
```

1. User approves the CCTPBridge contract to spend their USDC
2. User calls the `bridgeUSDC` function on the CCTPBridge contract
3. CCTPBridge transfers USDC from the user to itself
4. CCTPBridge approves the TokenMessenger to spend the USDC
5. CCTPBridge calls the TokenMessenger's `depositForBurn` function
6. TokenMessenger burns the USDC on the source chain and emits a message
7. The message is attested by Circle and relayed to the destination chain
8. TokenMessenger on the destination chain mints native USDC to the recipient's address

## Circle's Cross-Chain Transfer Protocol (CCTP)

### What is CCTP?

CCTP (Cross-Chain Transfer Protocol) is Circle's permissionless on-chain utility that enables native USDC transfers across different blockchains. It works by burning USDC on the source chain and minting an equivalent amount on the destination chain, ensuring that the total supply of USDC remains constant.

### How CCTP Works

1. **Burn**: USDC is burned on the source chain, and a "burn event" is emitted
2. **Attest**: Circle attests to the burn event, creating a message that can be verified on-chain
3. **Mint**: The message is used to mint an equivalent amount of USDC on the destination chain

### Domain IDs

Circle uses specific domain IDs to identify chains in CCTP:

- Ethereum: 0
- Avalanche: 1
- Optimism: 2
- Arbitrum: 3
- Solana: 5
- Base: 6

These domain IDs are used in the protocol to specify the destination chain when initiating a cross-chain transfer.

## Smart Contract Documentation

### CCTPBridge.sol

The `CCTPBridge` contract is the main component of this project. It provides a simplified interface for users to bridge USDC between supported chains.

#### State Variables

- `tokenMessenger`: Address of Circle's TokenMessenger contract
- `usdcToken`: Address of the USDC token contract
- `owner`: Address of the contract owner (inherited from OpenZeppelin's Ownable)

#### Events

- `USDCBridged(address indexed sender, uint32 destinationDomain, address indexed recipient, uint256 amount)`: Emitted when USDC is successfully bridged

#### Functions

1. **Constructor**
   ```solidity
   constructor(address _tokenMessenger, address _usdcToken)
   ```
   Initializes the contract with the addresses of the TokenMessenger and USDC token.

2. **bridgeUSDC**
   ```solidity
   function bridgeUSDC(uint32 destinationDomain, bytes32 destinationAddress, uint256 amount) external
   ```
   Bridges USDC to another chain by:
   - Transferring USDC from the sender to the contract
   - Approving the TokenMessenger to spend the USDC
   - Calling the TokenMessenger's depositForBurn function
   - Emitting a USDCBridged event

3. **rescueTokens**
   ```solidity
   function rescueTokens(address token, address to, uint256 amount) external onlyOwner
   ```
   Allows the owner to rescue any ERC20 tokens (including USDC) that might be stuck in the contract.

### Interfaces

#### ICCTPTokenMessenger.sol

Interface for Circle's TokenMessenger contract, which includes the `depositForBurn` function used to initiate the cross-chain transfer.

```solidity
function depositForBurn(
    uint256 amount,
    uint32 destinationDomain,
    bytes32 mintRecipient,
    address burnToken
) external returns (uint64 nonce);
```

#### IUSDC.sol

Simplified interface for the USDC token, including the standard ERC20 functions needed for the bridge operation.

### Mock Contracts (for Testing)

1. **MockTokenMessenger.sol**: Simulates Circle's TokenMessenger for testing purposes
2. **MockUSDC.sol**: Implements a mock USDC token for testing the bridge functionality

## Setup and Installation

### Prerequisites

- Node.js (v18+)
- npm or yarn
- An Ethereum wallet with private key
- RPC endpoints for the networks you want to use
- USDC on the source chain

### Installation Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/cctp-usdc-demo.git
   cd cctp-usdc-demo
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create and configure the `.env` file:
   ```bash
   cp .env.example .env
   # Edit the .env file with your API keys and private key
   ```

4. Required Environment Variables:
   ```
   PRIVATE_KEY=your_private_key
   GOERLI_RPC_URL=your_goerli_rpc_url
   ARBITRUM_RPC_URL=your_arbitrum_rpc_url
   ETHERSCAN_API_KEY=your_etherscan_api_key
   ARBISCAN_API_KEY=your_arbiscan_api_key
   ```

## Usage Guide

### Using the Makefile

The project includes a Makefile that simplifies common operations:

```bash
# Show all available commands
make help

# Compile the smart contracts
make compile

# Run all tests
make test

# Clean build artifacts
make clean

# Deploy to Goerli testnet
make deploy-goerli

# Deploy to Arbitrum testnet 
make deploy-arbitrum

# Bridge USDC from Goerli
make bridge-goerli
```

### Manual Command Execution

If you prefer not to use the Makefile, you can run the commands directly:

```bash
# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Deploy to Goerli
npx hardhat run scripts/deploy.ts --network goerli

# Bridge USDC from Goerli to Arbitrum
BRIDGE_ADDRESS=your_bridge_address USDC_ADDRESS=your_usdc_address DESTINATION_DOMAIN=3 npx hardhat run scripts/bridge-usdc.ts --network goerli
```

## Deployment Instructions

### Deploying to Testnet

1. Ensure your `.env` file is configured with the correct RPC URLs and private key
2. Make sure you have test USDC on the source chain (for testnets, you can get test USDC from Circle's faucet)
3. Deploy the bridge contract:
   ```bash
   make deploy-goerli
   # or
   npx hardhat run scripts/deploy.ts --network goerli
   ```
4. Note the deployed contract address for future use

### Bridging USDC

1. Set the required environment variables:
   ```bash
   export BRIDGE_ADDRESS=your_deployed_bridge_address
   export USDC_ADDRESS=your_usdc_address_on_source_chain
   export DESTINATION_DOMAIN=destination_chain_domain_id
   export DESTINATION_ADDRESS=recipient_address_on_destination_chain
   ```
2. Execute the bridge script:
   ```bash
   make bridge-goerli
   # or
   npx hardhat run scripts/bridge-usdc.ts --network goerli
   ```
3. Wait for the transaction to be confirmed on the source chain
4. Wait for Circle's attestation (typically 20-30 minutes)
5. The USDC will be automatically minted on the destination chain

## Troubleshooting

### Common Issues and Solutions

1. **Insufficient USDC Balance**
   - Ensure you have enough USDC on the source chain
   - For testnets, get test USDC from Circle's faucet

2. **Insufficient Gas**
   - Make sure you have enough native tokens (ETH, AVAX, etc.) for gas fees on both chains

3. **Failed Transaction**
   - Check that you have approved the bridge contract to spend your USDC
   - Verify that the TokenMessenger and USDC addresses are correct for the network

4. **Pending Transfer**
   - CCTP transfers typically take 20-30 minutes to finalize
   - Check the status of your transfer on Circle's CCTP Explorer

### Debugging Tips

- Use Etherscan (or the relevant block explorer) to verify if transactions were successful
- Check token approvals to ensure the bridge has allowance to spend your USDC
- Monitor Circle's CCTP Explorer for transfer status updates

## Security Considerations

- **Testing**: Always test transfers with small amounts first
- **Private Keys**: Ensure your private key is kept secure and not committed to version control
- **Contract Verification**: Verify contract addresses before interacting with them
- **Gas Costs**: Be aware of gas costs on both source and destination chains
- **Rescue Function**: The contract includes a rescue function that should only be callable by the owner

## Resources and References

- [CCTP Official Documentation](https://developers.circle.com/stablecoins/docs/cctp-getting-started)
- [CCTP Contract Addresses](https://developers.circle.com/stablecoins/docs/cctp-contract-addresses)
- [Circle Developer Portal](https://developers.circle.com/)
- [USDC on Different Chains](https://developers.circle.com/stablecoins/docs/supported-chains)
- [CCTP Explorer](https://cctp-explorer.circle.com/) 
# CCTP USDC Bridge Demo

This project demonstrates how to use [Circle's Cross-Chain Transfer Protocol (CCTP)](https://www.circle.com/en/cross-chain-transfer-protocol) to transfer USDC between different blockchains.

## Overview

Circle's Cross-Chain Transfer Protocol (CCTP) is a permissionless on-chain utility that can burn native USDC on a source chain and mint native USDC of the same amount on a destination chain. This enables fast, secure, and cost-effective transfers of USDC between supported blockchains.

This demo includes:

- Smart contracts for interacting with CCTP
- Scripts for deploying the contracts and executing USDC transfers
- Tests for verifying the contract functionality

## Supported Chains

CCTP currently supports USDC transfers between these chains:

- Ethereum
- Arbitrum
- Avalanche
- Optimism
- Base
- Solana (not covered in this Ethereum-focused demo)

## Prerequisites

- Node.js (v18+)
- npm or yarn
- An Ethereum wallet with private key
- RPC endpoints for the networks you want to use
- USDC on the source chain

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/cctp-usdc-demo.git
   cd cctp-usdc-demo
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Create a `.env` file from the example:
   ```
   cp .env.example .env
   ```

4. Edit the `.env` file with your API keys and private key.

## Project Structure

```
cctp-usdc-demo/
├── contracts/
│   ├── CCTPBridge.sol         # Main contract for CCTP interactions
│   ├── interfaces/
│   │   └── ICCTPTokenMessenger.sol  # Interface for Circle's TokenMessenger
│   │   └── IUSDC.sol                # Interface for USDC token
│   ├── mocks/                 # Mock contracts for testing
├── scripts/
│   ├── deploy.js              # Deployment script
│   └── bridge-usdc.js         # Script to test USDC bridging
├── test/
│   └── CCTPBridge.test.js     # Test cases
├── .env.example               # Template for environment variables
├── hardhat.config.js          # Hardhat configuration
├── package.json               # Dependencies and scripts
└── README.md                  # Project documentation
```

## Usage

### Deploying the Bridge Contract

```bash
# Deploy to Goerli testnet
npx hardhat run scripts/deploy.js --network goerli

# Deploy to Arbitrum testnet
npx hardhat run scripts/deploy.js --network arbitrum
```

### Bridging USDC

After deploying the contract, update your `.env` file with the deployed contract address, then run:

```bash
# Set environment variables for the bridging operation
export BRIDGE_ADDRESS=0x...your_deployed_contract_address
export USDC_ADDRESS=0x...usdc_address_on_source_chain
export DESTINATION_DOMAIN=3  # For Arbitrum
export DESTINATION_ADDRESS=0x...recipient_address  # Optional

# Execute the bridging
npx hardhat run scripts/bridge-usdc.js --network goerli
```

### Running Tests

```bash
npx hardhat test
```

## Domain IDs

Circle uses specific domain IDs to identify chains in CCTP:

- Ethereum: 0
- Avalanche: 1
- Optimism: 2
- Arbitrum: 3
- Base: 6
- Solana: 5

## Important Contract Addresses

### Testnet (Goerli/Sepolia)

- USDC Token (Goerli): `0x07865c6e87b9f70255377e024ace6630c1eaa37f`
- TokenMessenger (Goerli): `0xd0c3da58f55358142b8d3e06c1c30c5c6114efe8`
- USDC Token (Arbitrum Goerli): `0xfd064a18f3bf249cf1f87fc203e90d8f650f2d63`
- TokenMessenger (Arbitrum Goerli): `0x12dcfd3fe2e9eac2859fd1ed86d2ab8c5a2f9352`

### Mainnet

- USDC Token (Ethereum): `0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48`
- TokenMessenger (Ethereum): `0xbd3fa81b58ba92a82136038b25adec7066af3155`
- USDC Token (Arbitrum): `0xaf88d065e77c8cc2239327c5edb3a432268e5831`
- TokenMessenger (Arbitrum): `0x19330d10d9cc8751218eaf51e8885d058642e08a`

## Security Considerations

- Always test transactions with small amounts first
- Ensure your private key is kept secure and not committed to version control
- Verify contract addresses before interacting with them
- Be aware of gas costs on both source and destination chains

## Resources

- [CCTP Official Documentation](https://developers.circle.com/stablecoins/docs/cctp-getting-started)
- [CCTP Contract Addresses](https://developers.circle.com/stablecoins/docs/cctp-contract-addresses)
- [Circle Developer Portal](https://developers.circle.com/)

## License

This project is licensed under the MIT License - see the LICENSE file for details. 
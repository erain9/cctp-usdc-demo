# CCTP USDC Bridge Documentation

Welcome to the official documentation for the CCTP USDC Bridge project! This project demonstrates how to use [Circle's Cross-Chain Transfer Protocol (CCTP)](https://www.circle.com/en/cross-chain-transfer-protocol) to transfer USDC between different blockchains securely and efficiently.

## Documentation Overview

This documentation is organized into the following sections:

### Getting Started

- [Quick Start Guide](./quick-start-guide.md) - Get up and running with the project in 5 minutes
- [Project Documentation](./project-documentation.md) - Comprehensive documentation of the entire project

### Technical Details

- [Security Considerations](./security-considerations.md) - Important security aspects for CCTP bridge implementations

## Key Features

- Simple and secure USDC bridging between supported blockchains
- Full TypeScript support
- Comprehensive testing
- Easy deployment to testnets and mainnet
- Example scripts for bridging USDC

## Supported Chains

The CCTP USDC Bridge supports all chains that Circle's CCTP protocol supports, including:

- Ethereum
- Arbitrum
- Avalanche
- Optimism
- Base
- Solana (through external integrations)

## Quick Links

- [Circle's CCTP Documentation](https://developers.circle.com/stablecoins/docs/cctp-getting-started)
- [CCTP Contract Addresses](https://developers.circle.com/stablecoins/docs/cctp-contract-addresses)
- [CCTP Explorer](https://cctp-explorer.circle.com/)

## Repository Structure

```
cctp-usdc-demo/
├── contracts/             # Smart contracts
│   ├── CCTPBridge.sol     # Main bridge contract
│   ├── interfaces/        # Interface definitions
│   └── mocks/             # Mock contracts for testing
├── scripts/               # Deployment and bridging scripts
├── test/                  # Test files
├── docs/                  # Documentation
└── hardhat.config.ts      # Hardhat configuration
```

## Getting Help

If you encounter any issues or have questions:

1. Check the troubleshooting section in the [project documentation](./project-documentation.md#troubleshooting)
2. Open an issue on GitHub
3. Refer to Circle's [developer resources](https://developers.circle.com/)

## License

This project is licensed under the MIT License - see the LICENSE file in the main repository for details. 
# CCTP USDC Bridge: Quick Start Guide

This guide will help you get started with the CCTP USDC Bridge project in just a few minutes.

## Prerequisites

- Node.js v18 or higher
- npm or yarn
- Git
- An Ethereum wallet with testnet ETH and USDC
- RPC endpoints for testnets (Goerli/Sepolia and Arbitrum Goerli)

## Setup in 5 Minutes

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/cctp-usdc-demo.git
cd cctp-usdc-demo
```

### 2. Install Dependencies

```bash
npm install
# or
yarn install
```

### 3. Configure Environment

Create a `.env` file in the project root:

```bash
cp .env.example .env
```

Edit the `.env` file with your own values:

```
PRIVATE_KEY=your_wallet_private_key
GOERLI_RPC_URL=https://goerli.infura.io/v3/your_infura_key
ARBITRUM_RPC_URL=https://goerli-rollup.arbitrum.io/rpc
ETHERSCAN_API_KEY=your_etherscan_api_key
ARBISCAN_API_KEY=your_arbiscan_api_key
```

### 4. Compile Contracts

```bash
npx hardhat compile
# or
make compile
```

### 5. Run Tests

```bash
npx hardhat test
# or
make test
```

## Deploy to Testnet

### 1. Deploy to Goerli

```bash
npx hardhat run scripts/deploy.ts --network goerli
# or
make deploy-goerli
```

Save the deployed contract address for the next step.

### 2. Bridge USDC from Goerli to Arbitrum

Set the necessary environment variables:

```bash
export BRIDGE_ADDRESS=your_deployed_bridge_address
export USDC_ADDRESS=0x07865c6e87b9f70255377e024ace6630c1eaa37f  # Goerli USDC
export DESTINATION_DOMAIN=3  # Arbitrum domain ID
```

Then run the bridge script:

```bash
npx hardhat run scripts/bridge-usdc.ts --network goerli
# or
make bridge-goerli
```

## Key Concepts

### CCTP Domain IDs

- Ethereum: 0
- Avalanche: 1
- Optimism: 2
- Arbitrum: 3
- Solana: 5
- Base: 6

### Transfer Process

1. User calls `bridgeUSDC` on the CCTPBridge contract
2. USDC is transferred to the bridge contract
3. Bridge approves Circle's TokenMessenger to spend the USDC
4. TokenMessenger burns the USDC and emits a message
5. Circle attests to the message (takes 20-30 minutes)
6. Native USDC is minted on the destination chain

## Contract Integration Example

If you want to integrate with the CCTPBridge in your own contract:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ICCTPBridge {
    function bridgeUSDC(uint32 destinationDomain, bytes32 destinationAddress, uint256 amount) external;
}

contract YourContract {
    ICCTPBridge public bridge;
    IERC20 public usdc;
    
    constructor(address _bridge, address _usdc) {
        bridge = ICCTPBridge(_bridge);
        usdc = IERC20(_usdc);
    }
    
    function sendFundsToAnotherChain(uint32 destinationDomain, address recipient, uint256 amount) external {
        // Convert recipient address to bytes32
        bytes32 recipientBytes32 = bytes32(uint256(uint160(recipient)));
        
        // Transfer USDC from user to this contract
        usdc.transferFrom(msg.sender, address(this), amount);
        
        // Approve bridge to spend USDC
        usdc.approve(address(bridge), amount);
        
        // Bridge the USDC
        bridge.bridgeUSDC(destinationDomain, recipientBytes32, amount);
    }
}
```

## Troubleshooting

### Common Issues

- **Insufficient USDC**: Ensure you have enough USDC in your wallet
- **Insufficient ETH**: You need ETH for gas on both chains
- **Approval Failed**: Check that you've approved the bridge to spend your USDC
- **Transaction Reverted**: Verify contract addresses and parameters

### Getting Testnet Tokens

- **Goerli ETH**: Use a faucet like https://goerlifaucet.com/
- **Goerli USDC**: Use Circle's developer faucet at https://developers.circle.com/
- **Arbitrum Goerli ETH**: Use the Arbitrum bridge or a faucet

## Next Steps

- Read the full [project documentation](./project-documentation.md)
- Review [security considerations](./security-considerations.md)
- Explore Circle's [official CCTP documentation](https://developers.circle.com/stablecoins/docs/cctp-getting-started)

## Need Help?

- Open an issue on GitHub
- Check the [troubleshooting section](./project-documentation.md#troubleshooting) in the main documentation
- Visit Circle's developer forum at https://developers.circle.com/develop/forums 
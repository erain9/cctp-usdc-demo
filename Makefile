.PHONY: all compile test clean deploy-goerli deploy-arbitrum bridge-goerli help

# Default target
all: help

# Colors for terminal output
YELLOW=\033[0;33m
GREEN=\033[0;32m
NC=\033[0m # No Color

# Help command
help:
	@echo "${YELLOW}CCTP USDC Bridge Demo - Available Commands${NC}"
	@echo ""
	@echo "${GREEN}make compile${NC}        - Compile the smart contracts"
	@echo "${GREEN}make test${NC}           - Run all tests"
	@echo "${GREEN}make clean${NC}          - Remove build artifacts"
	@echo "${GREEN}make deploy-goerli${NC}  - Deploy contracts to Goerli testnet"
	@echo "${GREEN}make deploy-arbitrum${NC} - Deploy contracts to Arbitrum testnet"
	@echo "${GREEN}make bridge-goerli${NC}  - Bridge USDC from Goerli to another chain"
	@echo ""
	@echo "Set environment variables in .env file before deployment or bridging"

# Compile contracts
compile:
	@echo "${YELLOW}Compiling smart contracts...${NC}"
	npx hardhat compile

# Run tests
test:
	@echo "${YELLOW}Running tests...${NC}"
	npx hardhat test

# Clean build artifacts
clean:
	@echo "${YELLOW}Cleaning build artifacts...${NC}"
	rm -rf artifacts cache
	@echo "${GREEN}Done!${NC}"

# Deploy to Goerli testnet
deploy-goerli:
	@echo "${YELLOW}Deploying to Goerli testnet...${NC}"
	npx hardhat run scripts/deploy.js --network goerli

# Deploy to Arbitrum testnet
deploy-arbitrum:
	@echo "${YELLOW}Deploying to Arbitrum testnet...${NC}"
	npx hardhat run scripts/deploy.js --network arbitrum

# Bridge USDC from Goerli
bridge-goerli:
	@echo "${YELLOW}Bridging USDC from Goerli...${NC}"
	npx hardhat run scripts/bridge-usdc.js --network goerli 
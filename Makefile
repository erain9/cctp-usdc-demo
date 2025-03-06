# ====================================================================
# CCTP USDC Bridge Demo Makefile
# 
# This Makefile provides simple commands to compile, test, deploy, 
# and interact with the CCTP USDC Bridge smart contracts.
# ====================================================================

# Mark all targets as phony (not producing files matching the target name)
.PHONY: all compile test clean deploy-goerli deploy-arbitrum bridge-goerli help

# Default target when running just 'make' without arguments
all: help

# ANSI color codes for prettier terminal output
YELLOW=\033[0;33m
GREEN=\033[0;32m
NC=\033[0m # No Color

# --------------------------------------
# Help command - lists all available commands
# --------------------------------------
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

# --------------------------------------
# Compile - transpiles Solidity to bytecode and generates artifacts
# --------------------------------------
compile:
	@echo "${YELLOW}Compiling smart contracts...${NC}"
	npx hardhat compile # This uses Hardhat to compile all contracts in the contracts/ directory

# --------------------------------------
# Test - runs the test suite to verify contract functionality
# --------------------------------------
test:
	@echo "${YELLOW}Running tests...${NC}"
	npx hardhat test # Runs all tests in the test/ directory using Hardhat's test runner

# --------------------------------------
# Clean - removes build artifacts to ensure clean compilation
# --------------------------------------
clean:
	@echo "${YELLOW}Cleaning build artifacts...${NC}"
	rm -rf artifacts cache # Remove Hardhat compilation artifacts and cache
	@echo "${GREEN}Done!${NC}"

# --------------------------------------
# Deploy commands - deploys contracts to different networks
# 
# Note: Make sure your .env file contains:
# - GOERLI_RPC_URL or ARBITRUM_RPC_URL 
# - PRIVATE_KEY for the deployer account
# --------------------------------------
deploy-goerli:
	@echo "${YELLOW}Deploying to Goerli testnet...${NC}"
	npx hardhat run scripts/deploy.js --network goerli # Runs deployment script on Goerli

deploy-arbitrum:
	@echo "${YELLOW}Deploying to Arbitrum testnet...${NC}"
	npx hardhat run scripts/deploy.js --network arbitrum # Runs deployment script on Arbitrum

# --------------------------------------
# Bridge USDC - executes USDC bridging from Goerli to destination chain
#
# Note: Requires the following in .env or as environment variables:
# - BRIDGE_ADDRESS (your deployed contract)
# - USDC_ADDRESS (source chain USDC)
# - DESTINATION_DOMAIN (optional, defaults to Arbitrum)
# - DESTINATION_ADDRESS (optional, defaults to sender)
# --------------------------------------
bridge-goerli:
	@echo "${YELLOW}Bridging USDC from Goerli...${NC}"
	npx hardhat run scripts/bridge-usdc.js --network goerli # Executes bridging script 
import { ethers, run } from "hardhat";

interface NetworkConfig {
  [key: string]: {
    tokenMessenger: string;
    usdc: string;
  };
}

async function main(): Promise<void> {
  console.log("Deploying CCTPBridge contract...");

  // Get the network configuration - these would be actual addresses from Circle's documentation
  const networkConfig: NetworkConfig = {
    // Ethereum Goerli testnet
    goerli: {
      tokenMessenger: "0xd0c3da58f55358142b8d3e06c1c30c5c6114efe8",
      usdc: "0x07865c6e87b9f70255377e024ace6630c1eaa37f"
    },
    // Arbitrum Goerli testnet
    arbitrumGoerli: {
      tokenMessenger: "0x12dcfd3fe2e9eac2859fd1ed86d2ab8c5a2f9352",
      usdc: "0xfd064a18f3bf249cf1f87fc203e90d8f650f2d63"
    }
  };

  // Get the current network
  const network = process.env.HARDHAT_NETWORK || "hardhat";
  const config = network === "arbitrum" ? networkConfig.arbitrumGoerli : networkConfig.goerli;

  // Deploy the bridge contract
  const CCTPBridge = await ethers.getContractFactory("CCTPBridge");
  const bridge = await CCTPBridge.deploy(config.tokenMessenger, config.usdc);

  await bridge.waitForDeployment();
  
  const address = await bridge.getAddress();
  console.log(`CCTPBridge deployed to: ${address}`);
  console.log(`Using TokenMessenger: ${config.tokenMessenger}`);
  console.log(`Using USDC: ${config.usdc}`);

  console.log("Waiting for confirmations...");
  // Wait for 5 confirmations for better visibility on block explorers
  await bridge.deploymentTransaction()?.wait(5);
  
  console.log("Verifying contract on Etherscan...");
  await run("verify:verify", {
    address: address,
    constructorArguments: [config.tokenMessenger, config.usdc],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  }); 
const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main() {
  // Configuration
  const amount = ethers.parseUnits("10", 6); // 10 USDC (USDC has 6 decimals)
  
  // Domain IDs for different chains (from Circle's documentation)
  const domains = {
    ethereum: 0, 
    avalanche: 1,
    arbitrum: 3,
    optimism: 2,
    base: 6
  };

  // Get parameters from command line or use defaults
  const destinationDomain = process.env.DESTINATION_DOMAIN || domains.arbitrum;
  const destinationAddress = process.env.DESTINATION_ADDRESS || (await ethers.getSigners())[0].address;
  
  // Convert address to bytes32 format required by CCTP
  const destinationAddressBytes32 = ethers.zeroPadValue(destinationAddress, 32);
  
  console.log(`Bridging ${ethers.formatUnits(amount, 6)} USDC`);
  console.log(`From: ${hre.network.name}`);
  console.log(`To Domain: ${destinationDomain}`);
  console.log(`Recipient: ${destinationAddress}`);

  // Get the bridge contract address from deployment
  const bridgeAddress = process.env.BRIDGE_ADDRESS;
  if (!bridgeAddress) {
    console.error("Please set BRIDGE_ADDRESS environment variable");
    process.exit(1);
  }

  // Get the USDC token address based on the network
  const usdcAddress = process.env.USDC_ADDRESS;
  if (!usdcAddress) {
    console.error("Please set USDC_ADDRESS environment variable");
    process.exit(1);
  }

  // Connect to contracts
  const bridge = await ethers.getContractAt("CCTPBridge", bridgeAddress);
  const usdc = await ethers.getContractAt("IUSDC", usdcAddress);

  // Approve USDC to be spent by the bridge
  console.log("Approving USDC...");
  const approveTx = await usdc.approve(bridgeAddress, amount);
  await approveTx.wait();
  console.log(`Approval confirmed: ${approveTx.hash}`);

  // Bridge the USDC
  console.log("Bridging USDC...");
  const bridgeTx = await bridge.bridgeUSDC(destinationDomain, destinationAddressBytes32, amount);
  await bridgeTx.wait();
  console.log(`Bridge transaction confirmed: ${bridgeTx.hash}`);
  
  console.log("USDC bridging initiated successfully!");
  console.log("Note: The receiving chain will process the message after finalization (usually 20-30 minutes)");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); 
import { expect } from "chai";
import { ethers } from "hardhat";
import { CCTPBridge, MockTokenMessenger, MockUSDC } from "../typechain-types";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";

describe("CCTPBridge", function () {
  let cctpBridge: CCTPBridge;
  let mockTokenMessenger: MockTokenMessenger;
  let mockUSDC: MockUSDC;
  let owner: SignerWithAddress;
  let user: SignerWithAddress;
  
  // Sample values for testing
  const destinationDomain = 3; // Arbitrum domain ID
  const amount = ethers.parseUnits("100", 6); // 100 USDC
  
  beforeEach(async function () {
    // Get signers
    [owner, user] = await ethers.getSigners();
    
    // Deploy mock contracts for testing
    const MockUSDC = await ethers.getContractFactory("MockUSDC");
    mockUSDC = await MockUSDC.deploy("USD Coin", "USDC", 6);
    
    const MockTokenMessenger = await ethers.getContractFactory("MockTokenMessenger");
    mockTokenMessenger = await MockTokenMessenger.deploy();
    
    // Deploy the bridge contract
    const CCTPBridge = await ethers.getContractFactory("CCTPBridge");
    cctpBridge = await CCTPBridge.deploy(
      await mockTokenMessenger.getAddress(),
      await mockUSDC.getAddress()
    );
    
    // Mint some USDC to the user for testing
    await mockUSDC.mint(user.address, amount);
  });
  
  describe("Initialization", function () {
    it("Should set the correct token messenger and USDC addresses", async function () {
      expect(await cctpBridge.tokenMessenger()).to.equal(await mockTokenMessenger.getAddress());
      expect(await cctpBridge.usdcToken()).to.equal(await mockUSDC.getAddress());
    });
    
    it("Should set the deployer as the owner", async function () {
      expect(await cctpBridge.owner()).to.equal(owner.address);
    });
  });
  
  describe("bridgeUSDC", function () {
    it("Should bridge USDC to another chain", async function () {
      // User approves bridge to spend their USDC
      await mockUSDC.connect(user).approve(await cctpBridge.getAddress(), amount);
      
      // Convert user address to bytes32 for the destination
      const destinationReceiver = ethers.zeroPadValue(user.address, 32);
      
      // Bridge the USDC
      await expect(cctpBridge.connect(user).bridgeUSDC(
        destinationDomain,
        destinationReceiver,
        amount
      ))
        .to.emit(cctpBridge, "USDCBridged")
        .withArgs(user.address, destinationDomain, user.address, amount);
    });
  });
  
  describe("rescueTokens", function () {
    it("Should allow owner to rescue tokens", async function () {
      // Send some USDC to the bridge contract
      await mockUSDC.mint(await cctpBridge.getAddress(), amount);
      
      // Rescue the tokens
      await cctpBridge.rescueTokens(
        await mockUSDC.getAddress(),
        owner.address,
        amount
      );
      
      // Check if tokens were transferred
      expect(await mockUSDC.balanceOf(owner.address)).to.equal(amount);
    });
    
    it("Should prevent non-owners from rescuing tokens", async function () {
      // Send some USDC to the bridge contract
      await mockUSDC.mint(await cctpBridge.getAddress(), amount);
      
      // Try to rescue tokens as a non-owner (should fail)
      await expect(
        cctpBridge.connect(user).rescueTokens(
          await mockUSDC.getAddress(),
          user.address,
          amount
        )
      ).to.be.revertedWithCustomError(cctpBridge, "OwnableUnauthorizedAccount");
    });
  });
}); 
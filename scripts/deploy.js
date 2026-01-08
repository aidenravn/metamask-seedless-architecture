const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  // 1️⃣ Deploy IdentityRegistry
  const IdentityRegistry = await hre.ethers.getContractFactory("IdentityRegistry");
  const identityRegistry = await IdentityRegistry.deploy();
  await identityRegistry.deployed();
  console.log("IdentityRegistry deployed to:", identityRegistry.address);

  // 2️⃣ Deploy GuardianRegistry
  const GuardianRegistry = await hre.ethers.getContractFactory("GuardianRegistry");
  const guardianRegistry = await GuardianRegistry.deploy();
  await guardianRegistry.deployed();
  console.log("GuardianRegistry deployed to:", guardianRegistry.address);

  // 3️⃣ Deploy ReputationContract with IdentityRegistry
  const ReputationContract = await hre.ethers.getContractFactory("ReputationContract");
  const reputation = await ReputationContract.deploy(identityRegistry.address);
  await reputation.deployed();
  console.log("ReputationContract deployed to:", reputation.address);

  // 4️⃣ Deploy MigrationHelper
  const MigrationHelper = await hre.ethers.getContractFactory("MigrationHelper");
  const migrationHelper = await MigrationHelper.deploy();
  await migrationHelper.deployed();
  console.log("MigrationHelper deployed to:", migrationHelper.address);

  // 5️⃣ Deploy a SeedlessAccount example
  const SeedlessAccount = await hre.ethers.getContractFactory("SeedlessAccount");
  const dailyLimit = hre.ethers.utils.parseEther("10"); // Example daily limit
  const threshold = 2; // Example guardian threshold
  const guardians = [deployer.address]; // Example single guardian
  const owner = deployer.address;

  const seedlessAccount = await SeedlessAccount.deploy(
    owner,
    guardians,
    threshold,
    dailyLimit,
    hre.ethers.constants.AddressZero, // MPC approval placeholder
    guardianRegistry.address
  );
  await seedlessAccount.deployed();
  console.log("SeedlessAccount deployed to:", seedlessAccount.address);

  console.log("\n✅ All contracts deployed successfully!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

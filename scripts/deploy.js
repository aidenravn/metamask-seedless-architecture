const hre = require("hardhat");

async function main() {
  const IdentityRegistry = await hre.ethers.getContractFactory("IdentityRegistry");
  const registry = await IdentityRegistry.deploy();
  await registry.deployed();
  console.log("IdentityRegistry deployed to:", registry.address);

  const Reputation = await hre.ethers.getContractFactory("ReputationContract");
  const reputation = await Reputation.deploy(registry.address);
  await reputation.deployed();
  console.log("ReputationContract deployed to:", reputation.address);

  const Migration = await hre.ethers.getContractFactory("MigrationHelper");
  const migration = await Migration.deploy();
  await migration.deployed();
  console.log("MigrationHelper deployed to:", migration.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

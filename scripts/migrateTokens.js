import { ethers } from "ethers";
import MigrationHelperABI from "../abi/MigrationHelper.json";

interface MigrateParams {
  provider: ethers.providers.Web3Provider;
  migrationHelperAddress: string;
  tokenAddress?: string;
  nftAddress?: string;
  tokenIds?: number[];
  stakeContractAddress?: string;
  oldAddress: string;
  newAddress: string;
}

export async function migrate({
  provider,
  migrationHelperAddress,
  tokenAddress,
  nftAddress,
  tokenIds = [],
  stakeContractAddress,
  oldAddress,
  newAddress
}: MigrateParams) {

  const signer = provider.getSigner();
  const migrationHelper = new ethers.Contract(migrationHelperAddress, MigrationHelperABI, signer);

  // ERC20 taşı
  if (tokenAddress) {
    const ERC20 = new ethers.Contract(tokenAddress, [
      "function balanceOf(address) view returns(uint256)",
      "function transfer(address,uint256) returns(bool)"
    ], signer);

    // Dry-run simulation
    try {
      await migrationHelper.callStatic.migrateERC20(ERC20.address, oldAddress, newAddress);
    } catch (err) {
      throw new Error("ERC20 migration simulation failed: " + err.message);
    }

    const tx1 = await migrationHelper.migrateERC20(ERC20.address, oldAddress, newAddress);
    await tx1.wait();
    console.log("✅ ERC20 token taşındı:", ERC20.address);
  }

  // ERC721 taşı
  if (nftAddress && tokenIds.length > 0) {
    const ERC721 = new ethers.Contract(nftAddress, [
      "function ownerOf(uint256) view returns(address)",
      "function safeTransferFrom(address,address,uint256)"
    ], signer);

    try {
      await migrationHelper.callStatic.migrateERC721(ERC721.address, oldAddress, tokenIds, newAddress);
    } catch (err) {
      throw new Error("ERC721 migration simulation failed: " + err.message);
    }

    const tx2 = await migrationHelper.migrateERC721(ERC721.address, oldAddress, tokenIds, newAddress);
    await tx2.wait();
    console.log("✅ NFT'ler taşındı:", tokenIds);
  }

  // Stake pozisyonu taşı
  if (stakeContractAddress) {
    const stakeContract = new ethers.Contract(stakeContractAddress, [
      "function withdraw(address) returns(uint256)",
      "function stake(address,uint256)"
    ], signer);

    try {
      await migrationHelper.callStatic.migrateStake(stakeContract.address, oldAddress, newAddress);
    } catch (err) {
      throw new Error("Stake migration simulation failed: " + err.message);
    }

    const tx3 = await migrationHelper.migrateStake(stakeContract.address, oldAddress, newAddress);
    await tx3.wait();
    console.log("✅ Stake pozisyonları taşındı");
  }

  console.log("🎉 Migration tamamlandı!");
}

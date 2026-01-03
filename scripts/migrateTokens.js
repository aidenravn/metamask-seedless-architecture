import { ethers } from "ethers";
import MigrationHelperABI from "../abi/MigrationHelper.json";

export async function migrate(provider, migrationHelperAddress, tokenAddress, nftAddress, tokenIds, stakeContractAddress, oldAddress, newAddress) {
  const signer = provider.getSigner();
  const migrationHelper = new ethers.Contract(migrationHelperAddress, MigrationHelperABI, signer);

  // ERC20 taşı
  if(tokenAddress){
    const ERC20 = new ethers.Contract(tokenAddress, ["function balanceOf(address) view returns(uint256)", "function transfer(address,uint256) returns(bool)"], signer);
    const tx1 = await migrationHelper.migrateERC20(ERC20.address, oldAddress, newAddress);
    await tx1.wait();
    console.log("ERC20 token taşındı");
  }

  // ERC721 taşı
  if(nftAddress && tokenIds.length > 0){
    const ERC721 = new ethers.Contract(nftAddress, ["function ownerOf(uint256) view returns(address)", "function safeTransferFrom(address,address,uint256)"], signer);
    const tx2 = await migrationHelper.migrateERC721(ERC721.address, tokenIds, oldAddress, newAddress);
    await tx2.wait();
    console.log("NFT'ler taşındı");
  }

  // Stake pozisyonu taşı
  if(stakeContractAddress){
    const stakeContract = new ethers.Contract(stakeContractAddress, ["function withdraw(address) returns(uint256)", "function stake(address,uint256)"], signer);
    const tx3 = await migrationHelper.migrateStake(stakeContract.address, oldAddress, newAddress);
    await tx3.wait();
    console.log("Stake pozisyonları taşındı");
  }

  console.log("Migration tamamlandı!");
}

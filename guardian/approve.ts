import { ethers } from "ethers";

export async function approveRecovery(wallet, newOwnerKey) {
  const contract = new ethers.Contract(wallet, ABI, signer);
  await contract.approveRecovery(newOwnerKey);
}

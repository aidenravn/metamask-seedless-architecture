import { ethers } from "ethers";

/**
 * Approve a recovery for a SeedlessAccount wallet.
 * Handles transaction simulation and returns the receipt.
 *
 * @param {string} wallet - SeedlessAccount contract address
 * @param {string} newOwnerKey - Address of the new owner
 * @param {ethers.Signer} signer - ethers.js signer
 * @returns {Promise<ethers.providers.TransactionReceipt>} - Transaction receipt
 */
export async function approveRecovery(wallet, newOwnerKey, signer) {
  const contract = new ethers.Contract(wallet, ABI, signer);

  // Transaction simulation (dry-run)
  try {
    await contract.callStatic.approveRecovery(newOwnerKey);
  } catch (err) {
    throw new Error("Simulation failed: " + err.message);
  }

  // Send actual transaction
  const tx = await contract.approveRecovery(newOwnerKey);
  const receipt = await tx.wait();

  // Optional: read updated recovery status
  const pendingOwner = await contract.pendingOwner();
  const recoveryApprovals = await contract.recoveryApprovalCount();

  console.log(`Recovery approved for new owner: ${pendingOwner}`);
  console.log(`Total guardian approvals: ${recoveryApprovals}`);

  return receipt;
}

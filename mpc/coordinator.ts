import { signWithDeviceShard } from "./device/deviceSigner";
import { signWithCloudShard } from "./cloud/cloudSigner";
import { guardianSign } from "./guardian/guardianNode";
import { combineSignatures } from "node-seal-ecdsa";

/**
 * Multi-Party Computation signing
 * Combines Device, Cloud, and Guardian shard signatures
 * Includes optional threshold checks and dry-run simulation
 *
 * @param {Buffer} userOpHash - The hash of the user operation to sign
 * @param {string} userToken - User auth token for cloud shard
 * @param {() => boolean} guardianThresholdCheck - Optional callback to verify guardian approval threshold
 * @returns {Promise<string>} Combined signature
 */
export async function mpcSign(
  userOpHash: Buffer,
  userToken: string,
  guardianThresholdCheck?: () => boolean
): Promise<string> {

  // 1️⃣ Dry-run simulation
  simulateSign(userOpHash);

  // 2️⃣ Device shard signature
  const sigDevice = await signWithDeviceShard(userOpHash, guardianThresholdCheck);

  // 3️⃣ Cloud shard signature
  const sigCloud = await signWithCloudShard(userOpHash, userToken, guardianThresholdCheck);

  // 4️⃣ Guardian shard signature
  const sigGuardian = await guardianSign(userOpHash, guardianThresholdCheck);

  // 5️⃣ Combine all signatures
  const combined = combineSignatures([sigDevice, sigCloud, sigGuardian]);

  // 6️⃣ Audit log
  console.log(`MPC Sign completed for hash ${userOpHash.toString("hex").slice(0, 8)}...`);

  return combined;
}

/** Placeholder dry-run / simulation */
function simulateSign(hash: Buffer) {
  if (!hash || hash.length === 0) throw new Error("Simulation failed: empty hash");
  // Future: AI risk scoring, MPC device check, guardian status
}

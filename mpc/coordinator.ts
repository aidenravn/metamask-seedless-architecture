import { signWithDeviceShard } from "./device/deviceSigner";
import { signWithCloudShard } from "./cloud/cloudSigner";
import { guardianSign } from "./guardian/guardianNode";
import { combineSignatures } from "node-seal-ecdsa";

export async function mpcSign(userOpHash: Buffer, userToken: string) {
  const sigA = await signWithDeviceShard(userOpHash);
  const sigB = await signWithCloudShard(userOpHash, userToken);
  const sigC = await guardianSign(userOpHash);

  return combineSignatures([sigA, sigB, sigC]);
}

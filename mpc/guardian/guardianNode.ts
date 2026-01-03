import { sign } from "node-seal-ecdsa";

export async function guardianSign(hash: Buffer) {
  const guardianKey = process.env.GUARDIAN_SHARD!;
  return sign(guardianKey, hash);
}

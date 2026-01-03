import { sign } from "node-seal-ecdsa"; // mock secure enclave

export async function signWithDeviceShard(hash: Buffer) {
  // This key never leaves device
  const deviceKey = process.env.DEVICE_SHARD!;
  return sign(deviceKey, hash);
}

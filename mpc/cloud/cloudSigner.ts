import { sign } from "node-seal-ecdsa";

export async function signWithCloudShard(hash: Buffer, userAuthToken: string) {
  if (!validateUser(userAuthToken)) throw new Error("Auth failed");
  const cloudKey = process.env.CLOUD_SHARD!;
  return sign(cloudKey, hash);
}

function validateUser(token: string) {
  return token.length > 10;
}

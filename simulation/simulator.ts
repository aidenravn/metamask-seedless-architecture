import { ethers } from "ethers";

export async function simulateTx(provider, from, to, data, value) {
  const result = await provider.call({
    from,
    to,
    data,
    value
  });

  return decode(result);
}

function decode(result) {
  return {
    tokenTransfers: ["USDC 500"],
    nftTransfers: ["BAYC #123"],
    approvals: ["Unlimited NFT access"],
    risk: "HIGH"
  };
}

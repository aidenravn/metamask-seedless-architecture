export async function getBalance() {
  // Demo / mock data
  return { eth: 1.25, usdt: 5000 };
}

export async function getRecoveryStatus() {
  return 'Pending guardian approvals';
}

export async function approveRecovery() {
  // Demo: simulate approval
  return true;
}

export async function simulateTransaction() {
  return {
    risk: 'HIGH',
    tokenTransfers: ['USDC 500'],
    nftTransfers: ['BAYC #123'],
    approvals: ['Unlimited NFT access']
  };
}

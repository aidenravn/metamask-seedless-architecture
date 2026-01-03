import React, { useState } from 'react';
import { simulateTransaction } from '../utils/api';

export default function TransactionSimulation() {
  const [result, setResult] = useState(null);

  const handleSimulate = async () => {
    const simResult = await simulateTransaction();
    setResult(simResult);
  };

  return (
    <div>
      <h2>Transaction Simulation</h2>
      <button onClick={handleSimulate}>Simulate Tx</button>
      {result && (
        <div style={{ marginTop: 10 }}>
          <p>Risk Level: {result.risk}</p>
          <p>Token Transfers: {result.tokenTransfers.join(', ')}</p>
          <p>NFT Transfers: {result.nftTransfers.join(', ')}</p>
          <p>Approvals: {result.approvals.join(', ')}</p>
        </div>
      )}
    </div>
  );
}

import React, { useState } from "react";
import { simulateTransaction } from "../utils/api";

interface SimulationResult {
  risk: string;
  tokenTransfers: string[];
  nftTransfers: string[];
  approvals: string[];
}

export default function TransactionSimulation() {
  const [result, setResult] = useState<SimulationResult | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSimulate = async () => {
    setLoading(true);
    setError(null);
    setResult(null);

    try {
      const simResult: SimulationResult = await simulateTransaction();
      setResult(simResult);

      // Optional audit log
      console.log("Transaction simulation result:", simResult);
    } catch (err: any) {
      setError(err.message || "Simulation failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ marginBottom: 20, padding: 10, border: "1px solid #ccc", borderRadius: 6 }}>
      <h2>📝 Transaction Simulation</h2>
      <button onClick={handleSimulate} disabled={loading} style={{ marginBottom: 10 }}>
        {loading ? "Simulating..." : "Simulate Tx"}
      </button>

      {error && <p style={{ color: "red" }}>{error}</p>}

      {result && (
        <div style={{ marginTop: 10 }}>
          <p><strong>Risk Level:</strong> {result.risk}</p>
          <p><strong>Token Transfers:</strong> {result.tokenTransfers.join(", ") || "None"}</p>
          <p><strong>NFT Transfers:</strong> {result.nftTransfers.join(", ") || "None"}</p>
          <p><strong>Approvals:</strong> {result.approvals.join(", ") || "None"}</p>
        </div>
      )}
    </div>
  );
}

import React, { useState, useEffect } from "react";
import { getBalanceForWallet, getNetworkName } from "../utils/api";

interface BalanceData {
  eth: number;
  tokens: { [symbol: string]: number };
}

export default function Balance() {
  const [balance, setBalance] = useState<BalanceData>({ eth: 0, tokens: {} });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [network, setNetwork] = useState<string>("");

  useEffect(() => {
    async function fetchBalance() {
      try {
        setLoading(true);
        const data = await getBalanceForWallet();
        const net = await getNetworkName();
        setBalance(data);
        setNetwork(net);
      } catch (err: any) {
        setError(err.message || "Error fetching balance");
      } finally {
        setLoading(false);
      }
    }
    fetchBalance();
  }, []);

  if (loading) return <p>Loading balances...</p>;
  if (error) return <p style={{ color: "red" }}>{error}</p>;

  return (
    <div style={{ marginBottom: 20, padding: 10, border: "1px solid #ccc", borderRadius: 6 }}>
      <h2>💰 Wallet Balance ({network})</h2>
      <p>ETH: {balance.eth}</p>
      {Object.keys(balance.tokens).map((symbol) => (
        <p key={symbol}>
          {symbol}: {balance.tokens[symbol]}
        </p>
      ))}
    </div>
  );
}

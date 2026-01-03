import React, { useState, useEffect } from 'react';
import { getBalance } from '../utils/api';

export default function Balance() {
  const [balance, setBalance] = useState({ eth: 0, usdt: 0 });

  useEffect(() => {
    async function fetchBalance() {
      const data = await getBalance();
      setBalance(data);
    }
    fetchBalance();
  }, []);

  return (
    <div style={{ marginBottom: 20 }}>
      <h2>Wallet Balance</h2>
      <p>ETH: {balance.eth}</p>
      <p>USDT: {balance.usdt}</p>
    </div>
  );
}

import React from "react";
import Balance from "./components/Balance";
import Recovery from "./components/Recovery";
import TransactionSimulation from "./components/TransactionSimulation";
import ERC20Migration from "./components/ERC20Migration";
import NFTMigration from "./components/NFTMigration";
import StakeMigration from "./components/StakeMigration";

function App() {
  return (
    <div style={{ padding: 20, fontFamily: "Arial, sans-serif", maxWidth: 900, margin: "0 auto" }}>
      <h1 style={{ marginBottom: 20 }}>🌱 Seedless Wallet MVP</h1>

      {/* Wallet balance */}
      <section style={{ marginBottom: 20 }}>
        <h2>💰 Wallet Balance</h2>
        <Balance />
      </section>

      {/* Recovery / MPC flow */}
      <section style={{ marginBottom: 20 }}>
        <h2>🛡️ Recovery & MPC</h2>
        <Recovery />
      </section>

      {/* Transaction simulation / dry-run */}
      <section style={{ marginBottom: 20 }}>
        <h2>📝 Transaction Simulation</h2>
        <TransactionSimulation />
      </section>

      {/* Asset migration */}
      <section style={{ marginBottom: 20 }}>
        <h2>🔄 Asset Migration</h2>
        <ERC20Migration />
        <NFTMigration />
        <StakeMigration />
      </section>

      <footer style={{ marginTop: 40, fontSize: 12, color: "#666" }}>
        ⚠️ Testnet only. Do not use with real funds.
      </footer>
    </div>
  );
}

export default App;

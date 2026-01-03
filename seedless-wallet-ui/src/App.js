import React from 'react';
import Balance from './components/Balance';
import Recovery from './components/Recovery';
import TransactionSimulation from './components/TransactionSimulation';

function App() {
  return (
    <div style={{ padding: 20, fontFamily: 'Arial' }}>
      <h1>Seedless Wallet MVP</h1>
      <Balance />
      <Recovery />
      <TransactionSimulation />
    </div>
  );
}

export default App;

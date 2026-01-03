import React, { useState } from "react";
import { ethers } from "ethers";
import ConnectWallet from "./components/ConnectWallet";
import LinkOldWallet from "./components/LinkOldWallet";
import ReputationStatus from "./components/ReputationStatus";
import MigrationUI from "./components/MigrationUI";

export default function App() {
  const [provider, setProvider] = useState(null);

  return (
    <div style={{ padding: 20 }}>
      <h1>MetaMask Seedless Starter</h1>
      <ConnectWallet setProvider={setProvider} />
      {provider && (
        <>
          <hr />
          <LinkOldWallet
            provider={provider}
            newAddress="0xNEW_SEEDLESS_ADDRESS"
            registryAddress="0xREGISTRY_ADDRESS"
          />
          <hr />
          <ReputationStatus
            provider={provider}
            repContractAddress="0xREPUTATION_ADDRESS"
          />
          <hr />
          <MigrationUI
            provider={provider}
            migrationHelperAddress="0xMIGRATION_ADDRESS"
          />
        </>
      )}
    </div>
  );
}

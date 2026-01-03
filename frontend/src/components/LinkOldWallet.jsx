import React, { useState } from "react";
import { signLink } from "../utils/signature";
import { ethers } from "ethers";
import IdentityRegistryABI from "../abi/IdentityRegistry.json";

export default function LinkOldWallet({ provider, newAddress, registryAddress }) {
  const [status, setStatus] = useState("");

  const linkWallet = async () => {
    try {
      const signer = provider.getSigner();
      const oldAddress = await signer.getAddress();
      const signature = await signLink(signer, newAddress);

      const registry = new ethers.Contract(registryAddress, IdentityRegistryABI, signer);
      const tx = await registry.linkOldAddress(oldAddress, signature);
      await tx.wait();
      setStatus("Eski cüzdan başarıyla bağlandı!");
    } catch (e) {
      console.error(e);
      setStatus("Bağlama sırasında hata oluştu.");
    }
  };

  return (
    <div>
      <button onClick={linkWallet}>Eski Cüzdanı Bağla</button>
      <p>{status}</p>
    </div>
  );
}

import React, { useState } from "react";
import { migrate } from "../scripts/migrateTokens";

export default function MigrationUI({ provider, migrationHelperAddress }) {
  const [status, setStatus] = useState("");

  const handleMigrate = async () => {
    setStatus("Migration başlatıldı...");
    try {
      const oldAddress = prompt("Eski cüzdan adresi");
      const newAddress = prompt("Yeni Seedless cüzdan adresi");
      // Örnek: token, nft ve stake kontrat adresleri
      await migrate(provider, migrationHelperAddress,
                    "0xTOKEN",       // ERC20 token
                    "0xNFT",         // ERC721
                    [1,2,3],         // NFT tokenIds
                    "0xSTAKE",       // Stake kontratı
                    oldAddress,
                    newAddress);
      setStatus("Migration tamamlandı!");
    } catch (e) {
      console.error(e);
      setStatus("Migration sırasında hata oluştu.");
    }
  };

  return (
    <div>
      <button onClick={handleMigrate}>Token / NFT / Stake Taşı</button>
      <p>{status}</p>
    </div>
  );
}

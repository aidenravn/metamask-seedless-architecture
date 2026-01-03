import { ethers } from "ethers";

// Eski cüzdan ile link imzası oluştur
export async function signLink(oldWallet, newAddress) {
  const message = `Link to ${newAddress}`;
  const signature = await oldWallet.signMessage(message);
  return signature;
}

// Signature doğrulama için backend / kontrat kullanılacak

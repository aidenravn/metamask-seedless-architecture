import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import ReputationABI from "../abi/ReputationContract.json";

export default function ReputationStatus({ provider, repContractAddress }) {
  const [rep, setRep] = useState(0);

  useEffect(() => {
    const fetchRep = async () => {
      const signer = provider.getSigner();
      const account = await signer.getAddress();
      const contract = new ethers.Contract(repContractAddress, ReputationABI, signer);
      const totalRep = await contract.getReputation(account);
      setRep(totalRep.toNumber());
    };
    fetchRep();
  }, [provider]);

  return <div>Toplam Reputation: {rep}</div>;
}

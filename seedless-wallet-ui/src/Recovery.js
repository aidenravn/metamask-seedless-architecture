import React, { useState } from 'react';
import { getRecoveryStatus, approveRecovery } from '../utils/api';

export default function Recovery() {
  const [status, setStatus] = useState('No pending recovery');
  const [loading, setLoading] = useState(false);

  const handleApprove = async () => {
    setLoading(true);
    await approveRecovery();
    const newStatus = await getRecoveryStatus();
    setStatus(newStatus);
    setLoading(false);
  };

  return (
    <div style={{ marginBottom: 20 }}>
      <h2>Guardian Recovery</h2>
      <p>Status: {status}</p>
      <button onClick={handleApprove} disabled={loading}>
        Approve Recovery
      </button>
    </div>
  );
}

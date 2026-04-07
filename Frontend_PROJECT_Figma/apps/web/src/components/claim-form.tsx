import { FormEvent, useState } from 'react';

interface ClaimFormProps {
  onClaim: (deviceId: string, claimCode: string, name?: string) => Promise<void>;
}

export function ClaimForm({ onClaim }: ClaimFormProps) {
  const [deviceId, setDeviceId] = useState('');
  const [claimCode, setClaimCode] = useState('');
  const [name, setName] = useState('');

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    await onClaim(deviceId, claimCode, name || undefined);
    setDeviceId('');
    setClaimCode('');
    setName('');
  }

  return (
    <form className="card" onSubmit={handleSubmit}>
      <h3>Claim device</h3>
      <input
        value={deviceId}
        onChange={(event) => setDeviceId(event.target.value)}
        placeholder="Device ID"
      />
      <input
        value={claimCode}
        onChange={(event) => setClaimCode(event.target.value)}
        placeholder="Claim code"
      />
      <input
        value={name}
        onChange={(event) => setName(event.target.value)}
        placeholder="Optional name"
      />
      <button type="submit">Claim</button>
    </form>
  );
}

import { useCallback } from 'react';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { apiClient } from '../api/client';
import { ClaimForm } from '../components/claim-form';
import { DeviceCard } from '../components/device-card';
import { useAuth } from '../context/auth-context';
import { useDeviceEvents } from '../hooks/use-device-events';
import { DeviceSummary } from '../types';

export function DashboardPage() {
  const { token, signOut } = useAuth();
  const queryClient = useQueryClient();
  const devicesQuery = useQuery({
    queryKey: ['devices'],
    queryFn: () => apiClient.getDevices(token!),
    enabled: Boolean(token),
  });

  const refresh = useCallback(() => {
    void queryClient.invalidateQueries({ queryKey: ['devices'] });
  }, [queryClient]);

  useDeviceEvents({ token, onEvent: refresh });

  async function handleToggle(device: DeviceSummary) {
    await apiClient.sendPowerCommand(device.deviceId, !device.relayOn, token!);
    refresh();
  }

  async function handleClaim(deviceId: string, claimCode: string, name?: string) {
    await apiClient.claimDevice(deviceId, claimCode, token!, name);
    refresh();
  }

  return (
    <main className="page">
      <header className="page-header">
        <div>
          <h1>My Devices</h1>
          <p>Live power nodes synced from Docker-hosted Smartify API</p>
        </div>
        <button onClick={signOut} type="button">
          Sign Out
        </button>
      </header>
      <ClaimForm onClaim={handleClaim} />
      <section className="card-grid">
        {devicesQuery.data?.map((device) => (
          <DeviceCard device={device} key={device.deviceId} onToggle={handleToggle} />
        ))}
      </section>
    </main>
  );
}

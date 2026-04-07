import { useCallback } from 'react';
import { Link, useParams } from 'react-router-dom';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { apiClient } from '../api/client';
import { MetricGrid } from '../components/metric-grid';
import { useAuth } from '../context/auth-context';
import { useDeviceEvents } from '../hooks/use-device-events';

export function DeviceDetailPage() {
  const { deviceId = '' } = useParams();
  const { token } = useAuth();
  const queryClient = useQueryClient();
  const detailQuery = useQuery({
    queryKey: ['device', deviceId],
    queryFn: () => apiClient.getDevice(deviceId, token!),
    enabled: Boolean(token && deviceId),
  });
  const historyQuery = useQuery({
    queryKey: ['history', deviceId],
    queryFn: () => apiClient.getHistory(deviceId, token!),
    enabled: Boolean(token && deviceId),
  });

  const refresh = useCallback(() => {
    void queryClient.invalidateQueries({ queryKey: ['device', deviceId] });
    void queryClient.invalidateQueries({ queryKey: ['history', deviceId] });
  }, [deviceId, queryClient]);

  useDeviceEvents({ token, deviceId, onEvent: refresh });

  async function handleToggle() {
    const detail = detailQuery.data;
    if (!detail) return;
    await apiClient.sendPowerCommand(deviceId, !detail.relayOn, token!);
    refresh();
  }

  return (
    <main className="page">
      <Link to="/devices">Back to dashboard</Link>
      <header className="page-header">
        <div>
          <h1>{detailQuery.data?.name ?? deviceId}</h1>
          <p>{detailQuery.data?.relayOn ? 'Relay ON' : 'Relay OFF'}</p>
        </div>
        <button onClick={handleToggle} type="button">
          Toggle Relay
        </button>
      </header>
      <MetricGrid telemetry={detailQuery.data?.latestTelemetry ?? null} />
      <section className="card">
        <h3>Recent minute buckets</h3>
        <ul className="history-list">
          {historyQuery.data?.slice(-8).map((point, index) => (
            <li key={`${point.bucket ?? point.recordedAt}-${index}`}>
              <span>{point.bucket ?? point.recordedAt}</span>
              <strong>{Number(point.activePower).toFixed(2)} W</strong>
            </li>
          ))}
        </ul>
      </section>
    </main>
  );
}

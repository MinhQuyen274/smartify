import { Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { apiClient } from '../api/client';
import { useAuth } from '../context/auth-context';

export function ReportsPage() {
  const { token } = useAuth();
  const reportsQuery = useQuery({
    queryKey: ['reports'],
    queryFn: () => apiClient.getReportSummary(token!),
    enabled: Boolean(token),
  });

  return (
    <main className="page">
      <Link to="/devices">Back to dashboard</Link>
      <header className="page-header">
        <div>
          <h1>Reports</h1>
          <p>Total energy: {Number(reportsQuery.data?.totalEnergyKwh ?? 0).toFixed(2)} kWh</p>
        </div>
      </header>
      <section className="card">
        <table className="report-table">
          <thead>
            <tr>
              <th>Device</th>
              <th>Energy (kWh)</th>
              <th>Average Power (W)</th>
              <th>Last Telemetry</th>
            </tr>
          </thead>
          <tbody>
            {reportsQuery.data?.devices.map((device) => (
              <tr key={device.deviceId}>
                <td>{device.name}</td>
                <td>{Number(device.consumedEnergyKwh ?? 0).toFixed(2)}</td>
                <td>{Number(device.averagePower ?? 0).toFixed(2)}</td>
                <td>{device.lastTelemetryAt ?? '-'}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>
    </main>
  );
}

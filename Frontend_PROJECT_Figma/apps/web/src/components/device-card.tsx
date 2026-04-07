import { Link } from 'react-router-dom';
import { DeviceSummary } from '../types';

interface DeviceCardProps {
  device: DeviceSummary;
  onToggle: (device: DeviceSummary) => void;
}

export function DeviceCard({ device, onToggle }: DeviceCardProps) {
  const telemetry = device.latestTelemetry;

  return (
    <article className="card">
      <div className="card-row">
        <div>
          <h3>{device.name}</h3>
          <p>{device.deviceId}</p>
        </div>
        <span className={device.isOnline ? 'badge online' : 'badge offline'}>
          {device.isOnline ? 'Online' : 'Offline'}
        </span>
      </div>
      <p>Relay: {device.relayOn ? 'ON' : 'OFF'}</p>
      {telemetry ? (
        <div className="device-stats">
          <span className="last-seen">Last: {new Date(device.lastSeenAt!).toLocaleTimeString()}</span>
        </div>
      ) : (
        <p className="device-stats-empty">Waiting for telemetry</p>
      )}
      <div className="card-actions">
        <button onClick={() => onToggle(device)} type="button">
          Turn {device.relayOn ? 'OFF' : 'ON'}
        </button>
        <Link to={`/devices/${device.deviceId}`}>Details</Link>
      </div>
    </article>
  );
}

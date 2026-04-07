import { TelemetryPoint } from '../types';

interface MetricGridProps {
  telemetry: TelemetryPoint | null;
}

export function MetricGrid({ telemetry }: MetricGridProps) {
  const items = [
    ['Voltage', telemetry?.voltage ?? 0, 'V'],
    ['Current', telemetry?.current ?? 0, 'A'],
    ['Power', telemetry?.activePower ?? 0, 'W'],
    ['Energy', telemetry?.energyKwh ?? 0, 'kWh'],
    ['Frequency', telemetry?.frequency ?? 0, 'Hz'],
    ['Power Factor', telemetry?.powerFactor ?? 0, 'PF'],
  ];

  return (
    <section className="metric-grid">
      {items.map(([label, value, unit]) => (
        <article className="card" key={label}>
          <h4>{label}</h4>
          <strong>{Number(value).toFixed(2)}</strong>
          <span>{unit}</span>
        </article>
      ))}
    </section>
  );
}

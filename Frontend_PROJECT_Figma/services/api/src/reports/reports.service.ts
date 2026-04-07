import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { DeviceTelemetryEntity } from '../telemetry/device-telemetry.entity';

@Injectable()
export class ReportsService {
  constructor(
    @InjectRepository(DeviceTelemetryEntity)
    private readonly telemetryRepository: Repository<DeviceTelemetryEntity>,
  ) {}

  async getSummary(userId: string, fromQuery?: string, toQuery?: string) {
    const from = fromQuery ? new Date(fromQuery) : new Date(Date.now() - 30 * 86400000);
    const to = toQuery ? new Date(toQuery) : new Date();

    const rows = await this.telemetryRepository.query(
      `
        WITH deltas AS (
          SELECT
            t.device_id,
            t.recorded_at,
            t.relay_on,
            LAG(t.recorded_at) OVER (PARTITION BY t.device_id ORDER BY t.recorded_at) AS prev_at,
            LAG(t.relay_on) OVER (PARTITION BY t.device_id ORDER BY t.recorded_at) AS prev_on
          FROM device_telemetry t
          JOIN devices d ON d.id = t.device_id
          WHERE d.owner_id = $1 AND t.recorded_at BETWEEN $2 AND $3
        )
        SELECT
          d.device_id AS "deviceId",
          d.name,
          COALESCE(SUM(EXTRACT(EPOCH FROM (recorded_at - prev_at))) FILTER (WHERE relay_on = true AND prev_on = true), 0) / 3600 AS "onHours",
          MAX(recorded_at) AS "lastTelemetryAt"
        FROM deltas
        JOIN devices d ON d.id = deltas.device_id
        GROUP BY d.device_id, d.name
        ORDER BY d.name ASC
      `,
      [userId, from, to],
    );

    const totalOnHours = rows.reduce(
      (total: number, row: { onHours: number }) => total + Number(row.onHours),
      0,
    );

    return {
      totalOnHours,
      deviceCount: rows.length,
      devices: rows,
    };
  }
}

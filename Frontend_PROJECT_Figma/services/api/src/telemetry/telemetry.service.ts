import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Between, Repository } from 'typeorm';
import { DeviceTelemetryEntity } from './device-telemetry.entity';
import { DeviceEntity } from '../devices/device.entity';
import { DeviceHistoryQueryDto } from '../devices/dto/device-history-query.dto';

@Injectable()
export class TelemetryService {
  constructor(
    @InjectRepository(DeviceTelemetryEntity)
    private readonly telemetryRepository: Repository<DeviceTelemetryEntity>,
  ) {}

  async getLatest(device: DeviceEntity) {
    return this.telemetryRepository.findOne({
      where: { device: { id: device.id } },
      order: { recordedAt: 'DESC' },
    });
  }

  async getHistory(device: DeviceEntity, query: DeviceHistoryQueryDto) {
    const interval = query.interval ?? 'raw';
    const from = query.from ? new Date(query.from) : new Date(Date.now() - 86400000);
    const to = query.to ? new Date(query.to) : new Date();

    if (interval === 'raw') {
      return this.telemetryRepository.find({
        where: {
          device: { id: device.id },
          recordedAt: Between(from, to),
        },
        order: { recordedAt: 'ASC' },
      });
    }

    const rows = await this.telemetryRepository.query(
      `
        SELECT
          date_trunc($1, recorded_at) AS bucket,
          bool_or(relay_on) AS "relayOn"
        FROM device_telemetry
        WHERE device_id = $2 AND recorded_at BETWEEN $3 AND $4
        GROUP BY bucket
        ORDER BY bucket ASC
      `,
      [interval, device.id, from, to],
    );

    return rows;
  }
}

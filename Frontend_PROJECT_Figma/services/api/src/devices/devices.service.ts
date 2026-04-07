import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { DeviceEntity } from './device.entity';
import { TelemetryService } from '../telemetry/telemetry.service';
import { DeviceHistoryQueryDto } from './dto/device-history-query.dto';
import { DeviceTelemetryEntity } from '../telemetry/device-telemetry.entity';

@Injectable()
export class DevicesService {
  constructor(
    @InjectRepository(DeviceEntity)
    private readonly devicesRepository: Repository<DeviceEntity>,
    private readonly telemetryService: TelemetryService,
  ) {}

  async listForUser(userId: string) {
    const devices = await this.devicesRepository.find({
      where: { owner: { id: userId } },
      order: { createdAt: 'ASC' },
    });
    const latestTelemetry = await Promise.all(
      devices.map((device) => this.telemetryService.getLatest(device)),
    );

    return devices.map((device, index) => this.toSummary(device, latestTelemetry[index]));
  }

  async findOwnedDeviceOrThrow(deviceId: string, userId: string) {
    const device = await this.devicesRepository.findOne({
      where: { deviceId, owner: { id: userId } },
      relations: ['owner'],
    });

    if (!device) {
      throw new NotFoundException('Device not found');
    }

    return device;
  }

  async getDeviceDetail(deviceId: string, userId: string) {
    const device = await this.findOwnedDeviceOrThrow(deviceId, userId);
    const latest = await this.telemetryService.getLatest(device);
    return this.toSummary(device, latest);
  }

  async getLiveSnapshot(deviceId: string, userId: string) {
    return this.getDeviceDetail(deviceId, userId);
  }

  async getHistory(deviceId: string, userId: string, query: DeviceHistoryQueryDto) {
    const device = await this.findOwnedDeviceOrThrow(deviceId, userId);
    return this.telemetryService.getHistory(device, query);
  }

  toSummary(device: DeviceEntity, latestTelemetry: DeviceTelemetryEntity | null = null) {
    return {
      deviceId: device.deviceId,
      type: device.type,
      name: device.name,
      relayOn: device.relayOn,
      isOnline: device.isOnline,
      lastSeenAt: device.lastSeenAt,
      createdAt: device.createdAt,
      updatedAt: device.updatedAt,
      latestTelemetry,
    };
  }
}

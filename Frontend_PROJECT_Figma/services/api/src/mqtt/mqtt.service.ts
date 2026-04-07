import { Injectable, Logger, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import mqtt, { MqttClient } from 'mqtt';
import { Repository } from 'typeorm';
import { DeviceEntity } from '../devices/device.entity';
import { DeviceTelemetryEntity } from '../telemetry/device-telemetry.entity';
import { DeviceCommandEntity } from '../commands/device-command.entity';
import { RealtimeGateway } from '../realtime/realtime.gateway';

@Injectable()
export class MqttService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(MqttService.name);
  private client?: MqttClient;

  constructor(
    @InjectRepository(DeviceEntity)
    private readonly devicesRepository: Repository<DeviceEntity>,
    @InjectRepository(DeviceTelemetryEntity)
    private readonly telemetryRepository: Repository<DeviceTelemetryEntity>,
    @InjectRepository(DeviceCommandEntity)
    private readonly commandsRepository: Repository<DeviceCommandEntity>,
    private readonly realtimeGateway: RealtimeGateway,
  ) {}

  onModuleInit() {
    const url = process.env.MQTT_URL ?? 'mqtt://localhost:1883';
    this.client = mqtt.connect(url);
    this.client.on('connect', () => {
      this.logger.log(`Connected to MQTT at ${url}`);
      this.client?.subscribe('devices/+/telemetry');
      this.client?.subscribe('devices/+/state');
      this.client?.subscribe('devices/+/ack');
    });
    this.client.on('message', (topic, payload) => void this.handleMessage(topic, payload.toString()));
    this.client.on('error', (error) => this.logger.error(error.message));
  }

  onModuleDestroy() {
    this.client?.end(true);
  }

  async publishPowerCommand(deviceId: string, requestId: string, relayOn: boolean) {
    const topic = `devices/${deviceId}/command`;
    const payload = JSON.stringify({ requestId, relayOn });
    this.client?.publish(topic, payload);
  }

  private async handleMessage(topic: string, payload: string) {
    const [, deviceId, channel] = topic.split('/');
    if (!deviceId || !channel) return;

    if (channel === 'telemetry') await this.handleTelemetry(deviceId, payload);
    if (channel === 'state') await this.handleState(deviceId, payload);
    if (channel === 'ack') await this.handleAck(deviceId, payload);
  }

  private async handleTelemetry(deviceId: string, payload: string) {
    const device = await this.findDevice(deviceId);
    if (!device) return;
    const message = this.parseMessage(payload);
    if (!message) return;

    const telemetry = this.telemetryRepository.create({
      device,
      recordedAt: this.parseRecordedAt(message.ts),
      relayOn: Boolean(message.relayOn),
      source: 'telemetry',
    });

    device.isOnline = true;
    device.lastSeenAt = telemetry.recordedAt;
    device.relayOn = telemetry.relayOn;
    await this.devicesRepository.save(device);
    await this.telemetryRepository.save(telemetry);
    this.emitToOwner(device, 'telemetry.received', {
      deviceId,
      latestTelemetry: telemetry,
      relayOn: device.relayOn,
    });
  }

  private async handleState(deviceId: string, payload: string) {
    const device = await this.findDevice(deviceId);
    if (!device) return;
    const message = this.parseMessage(payload);
    if (!message) return;
    device.relayOn = Boolean(message.relayOn);
    device.isOnline = true;
    device.lastSeenAt = this.parseRecordedAt(message.ts);
    await this.devicesRepository.save(device);
    this.emitToOwner(device, 'device.updated', {
      deviceId,
      relayOn: device.relayOn,
      source: message.source ?? 'device',
      lastSeenAt: device.lastSeenAt,
    });
  }

  private async handleAck(deviceId: string, payload: string) {
    const device = await this.findDevice(deviceId);
    if (!device) return;
    const message = this.parseMessage(payload);
    if (!message) return;
    const command = await this.commandsRepository.findOne({
      where: { requestId: String(message.requestId ?? '') },
    });
    if (!command) return;

    command.acked = true;
    command.ackSuccess = Boolean(message.success);
    command.ackedAt = new Date();
    await this.commandsRepository.save(command);
    if (command.ackSuccess) {
      device.relayOn = Boolean(message.relayOn);
      await this.devicesRepository.save(device);
    }
    this.emitToOwner(device, 'command.acknowledged', {
      deviceId,
      requestId: command.requestId,
      relayOn: message.relayOn,
      success: command.ackSuccess,
    });
  }

  private async findDevice(deviceId: string) {
    return this.devicesRepository.findOne({
      where: { deviceId },
      relations: ['owner'],
    });
  }

  private emitToOwner(device: DeviceEntity, event: string, payload: unknown) {
    if (device.owner?.id) {
      this.realtimeGateway.emitUserEvent(device.owner.id, event, payload);
    }
    if (event === 'telemetry.received') {
      this.realtimeGateway.emitTelemetry(device.deviceId, payload);
    }
    if (event === 'command.acknowledged') {
      this.realtimeGateway.emitCommandAck(device.deviceId, payload);
    }
  }

  private parseMessage(payload: string) {
    try {
      return JSON.parse(payload) as Record<string, unknown>;
    } catch (error) {
      this.logger.warn(`Ignoring invalid MQTT payload: ${payload}`);
      return null;
    }
  }

  private parseRecordedAt(value: unknown) {
    if (typeof value === 'string') {
      const trimmed = value.trim();
      if (!trimmed) return new Date();
      if (/^\d+$/.test(trimmed)) {
        return this.parseNumericTimestamp(Number(trimmed));
      }
      const parsed = new Date(trimmed);
      if (!Number.isNaN(parsed.getTime())) {
        return parsed;
      }
      return new Date();
    }

    if (typeof value === 'number') {
      return this.parseNumericTimestamp(value);
    }

    return new Date();
  }

  private parseNumericTimestamp(value: number) {
    if (!Number.isFinite(value) || value <= 0) {
      return new Date();
    }

    if (value >= 1_000_000_000_000) {
      return new Date(value);
    }

    if (value >= 1_000_000_000) {
      return new Date(value * 1000);
    }

    return new Date();
  }
}

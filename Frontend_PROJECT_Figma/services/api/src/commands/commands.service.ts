import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { v4 as uuid } from 'uuid';
import { DeviceCommandEntity } from './device-command.entity';
import { DevicesService } from '../devices/devices.service';
import { MqttService } from '../mqtt/mqtt.service';
import { UserEntity } from '../auth/user.entity';

@Injectable()
export class CommandsService {
  constructor(
    @InjectRepository(DeviceCommandEntity)
    private readonly commandsRepository: Repository<DeviceCommandEntity>,
    private readonly devicesService: DevicesService,
    private readonly mqttService: MqttService,
  ) {}

  async sendPowerCommand(deviceId: string, relayOn: boolean, user: UserEntity) {
    const device = await this.devicesService.findOwnedDeviceOrThrow(deviceId, user.id);
    const requestId = uuid();
    const command = this.commandsRepository.create({
      device,
      requestId,
      desiredRelayOn: relayOn,
      source: 'remote_command',
      issuedByUser: user,
    });

    await this.commandsRepository.save(command);
    await this.mqttService.publishPowerCommand(device.deviceId, requestId, relayOn);

    return {
      requestId,
      deviceId: device.deviceId,
      relayOn,
      queuedAt: command.createdAt,
    };
  }
}

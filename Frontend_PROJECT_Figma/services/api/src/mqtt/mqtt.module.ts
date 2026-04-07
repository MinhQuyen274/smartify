import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DeviceEntity } from '../devices/device.entity';
import { DeviceTelemetryEntity } from '../telemetry/device-telemetry.entity';
import { DeviceCommandEntity } from '../commands/device-command.entity';
import { RealtimeModule } from '../realtime/realtime.module';
import { MqttService } from './mqtt.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([DeviceEntity, DeviceTelemetryEntity, DeviceCommandEntity]),
    RealtimeModule,
  ],
  providers: [MqttService],
  exports: [MqttService],
})
export class MqttModule {}

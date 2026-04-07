import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DeviceEntity } from './device.entity';
import { DevicesController } from './devices.controller';
import { DevicesService } from './devices.service';
import { TelemetryModule } from '../telemetry/telemetry.module';

@Module({
  imports: [TypeOrmModule.forFeature([DeviceEntity]), TelemetryModule],
  controllers: [DevicesController],
  providers: [DevicesService],
  exports: [DevicesService, TypeOrmModule],
})
export class DevicesModule {}

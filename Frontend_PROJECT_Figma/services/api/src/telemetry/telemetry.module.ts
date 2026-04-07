import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DeviceTelemetryEntity } from './device-telemetry.entity';
import { TelemetryService } from './telemetry.service';

@Module({
  imports: [TypeOrmModule.forFeature([DeviceTelemetryEntity])],
  providers: [TelemetryService],
  exports: [TelemetryService, TypeOrmModule],
})
export class TelemetryModule {}

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DeviceTelemetryEntity } from '../telemetry/device-telemetry.entity';
import { ReportsController } from './reports.controller';
import { ReportsService } from './reports.service';

@Module({
  imports: [TypeOrmModule.forFeature([DeviceTelemetryEntity])],
  controllers: [ReportsController],
  providers: [ReportsService],
})
export class ReportsModule {}

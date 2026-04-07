import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { buildDatabaseOptions } from './database/database.config';
import { AuthModule } from './auth/auth.module';
import { DevicesModule } from './devices/devices.module';
import { ClaimsModule } from './claims/claims.module';
import { TelemetryModule } from './telemetry/telemetry.module';
import { CommandsModule } from './commands/commands.module';
import { ReportsModule } from './reports/reports.module';
import { RealtimeModule } from './realtime/realtime.module';
import { MqttModule } from './mqtt/mqtt.module';

@Module({
  imports: [
    TypeOrmModule.forRoot(buildDatabaseOptions()),
    AuthModule,
    DevicesModule,
    ClaimsModule,
    TelemetryModule,
    CommandsModule,
    ReportsModule,
    RealtimeModule,
    MqttModule,
  ],
})
export class AppModule {}

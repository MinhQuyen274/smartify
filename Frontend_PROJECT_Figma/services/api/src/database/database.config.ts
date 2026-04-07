import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { DataSourceOptions } from 'typeorm';
import { UserEntity } from '../auth/user.entity';
import { DeviceEntity } from '../devices/device.entity';
import { DeviceClaimEntity } from '../claims/device-claim.entity';
import { DeviceTelemetryEntity } from '../telemetry/device-telemetry.entity';
import { DeviceCommandEntity } from '../commands/device-command.entity';
import { InitialSchema1711939200000 } from './migrations/1711939200000-initial-schema';

const databaseUrl =
  process.env.DATABASE_URL ??
  'postgresql://smartify:smartify@localhost:5432/smartify';

export const appEntities = [
  UserEntity,
  DeviceEntity,
  DeviceClaimEntity,
  DeviceTelemetryEntity,
  DeviceCommandEntity,
];

export const appMigrations = [InitialSchema1711939200000];

export function buildDatabaseOptions(): DataSourceOptions & TypeOrmModuleOptions {
  return {
    type: 'postgres',
    url: databaseUrl,
    entities: appEntities,
    migrations: appMigrations,
    synchronize: false,
    logging: false,
  };
}

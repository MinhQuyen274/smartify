import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { DeviceEntity } from '../devices/device.entity';

@Entity('device_telemetry')
export class DeviceTelemetryEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @ManyToOne(() => DeviceEntity, (device) => device.telemetry, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'device_id' })
  device!: DeviceEntity;

  @Column({ name: 'recorded_at', type: 'timestamptz' })
  recordedAt!: Date;

  @Column({ name: 'relay_on', type: 'boolean' })
  relayOn!: boolean;

  @Column({ type: 'varchar', default: 'telemetry' })
  source!: string;
}

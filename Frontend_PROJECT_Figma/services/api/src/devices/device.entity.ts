import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { UserEntity } from '../auth/user.entity';
import { DeviceClaimEntity } from '../claims/device-claim.entity';
import { DeviceTelemetryEntity } from '../telemetry/device-telemetry.entity';
import { DeviceCommandEntity } from '../commands/device-command.entity';

@Entity('devices')
export class DeviceEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ name: 'device_id', type: 'varchar', unique: true })
  deviceId!: string;

  @Column({ type: 'varchar' })
  type!: string;

  @Column({ type: 'varchar' })
  name!: string;

  @Column({ name: 'relay_on', type: 'boolean', default: false })
  relayOn!: boolean;

  @Column({ name: 'is_online', type: 'boolean', default: false })
  isOnline!: boolean;

  @Column({ name: 'last_seen_at', type: 'timestamptz', nullable: true })
  lastSeenAt!: Date | null;

  @ManyToOne(() => UserEntity, (user) => user.devices, { nullable: true })
  @JoinColumn({ name: 'owner_id' })
  owner!: UserEntity | null;

  @OneToOne(() => DeviceClaimEntity, (claim) => claim.device)
  claim!: DeviceClaimEntity | null;

  @OneToMany(() => DeviceTelemetryEntity, (telemetry) => telemetry.device)
  telemetry!: DeviceTelemetryEntity[];

  @OneToMany(() => DeviceCommandEntity, (command) => command.device)
  commands!: DeviceCommandEntity[];

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt!: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt!: Date;
}

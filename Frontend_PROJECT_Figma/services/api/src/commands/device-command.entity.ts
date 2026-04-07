import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { DeviceEntity } from '../devices/device.entity';
import { UserEntity } from '../auth/user.entity';

@Entity('device_commands')
export class DeviceCommandEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @ManyToOne(() => DeviceEntity, (device) => device.commands, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'device_id' })
  device!: DeviceEntity;

  @Column({ name: 'request_id', type: 'varchar', unique: true })
  requestId!: string;

  @Column({ name: 'desired_relay_on', type: 'boolean' })
  desiredRelayOn!: boolean;

  @Column({ type: 'varchar' })
  source!: string;

  @ManyToOne(() => UserEntity, (user) => user.commands, { nullable: true })
  @JoinColumn({ name: 'issued_by_user_id' })
  issuedByUser!: UserEntity | null;

  @Column({ type: 'boolean', default: false })
  acked!: boolean;

  @Column({ name: 'ack_success', type: 'boolean', nullable: true })
  ackSuccess!: boolean | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt!: Date;

  @Column({ name: 'acked_at', type: 'timestamptz', nullable: true })
  ackedAt!: Date | null;
}

import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { DeviceEntity } from '../devices/device.entity';
import { UserEntity } from '../auth/user.entity';

@Entity('device_claims')
export class DeviceClaimEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @OneToOne(() => DeviceEntity, (device) => device.claim)
  @JoinColumn({ name: 'device_id' })
  device!: DeviceEntity;

  @Column({ name: 'claim_code', type: 'varchar', unique: true })
  claimCode!: string;

  @ManyToOne(() => UserEntity, (user) => user.claims, { nullable: true })
  @JoinColumn({ name: 'claimed_by_user_id' })
  claimedByUser!: UserEntity | null;

  @Column({ name: 'claimed_at', type: 'timestamptz', nullable: true })
  claimedAt!: Date | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt!: Date;
}

import { Column, CreateDateColumn, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { DeviceEntity } from '../devices/device.entity';
import { DeviceClaimEntity } from '../claims/device-claim.entity';
import { DeviceCommandEntity } from '../commands/device-command.entity';

@Entity('users')
export class UserEntity {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'varchar', unique: true })
  email!: string;

  @Column({ name: 'password_hash', type: 'varchar' })
  passwordHash!: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt!: Date;

  @OneToMany(() => DeviceEntity, (device) => device.owner)
  devices!: DeviceEntity[];

  @OneToMany(() => DeviceClaimEntity, (claim) => claim.claimedByUser)
  claims!: DeviceClaimEntity[];

  @OneToMany(() => DeviceCommandEntity, (command) => command.issuedByUser)
  commands!: DeviceCommandEntity[];
}

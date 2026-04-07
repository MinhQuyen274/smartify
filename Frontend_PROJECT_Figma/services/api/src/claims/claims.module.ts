import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DeviceClaimEntity } from './device-claim.entity';
import { ClaimsController } from './claims.controller';
import { ClaimsService } from './claims.service';
import { DeviceEntity } from '../devices/device.entity';

@Module({
  imports: [TypeOrmModule.forFeature([DeviceClaimEntity, DeviceEntity])],
  controllers: [ClaimsController],
  providers: [ClaimsService],
  exports: [ClaimsService, TypeOrmModule],
})
export class ClaimsModule {}

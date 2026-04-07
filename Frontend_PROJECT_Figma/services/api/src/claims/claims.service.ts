import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { DeviceClaimEntity } from './device-claim.entity';
import { ClaimDeviceDto } from './dto/claim-device.dto';
import { UserEntity } from '../auth/user.entity';
import { DeviceEntity } from '../devices/device.entity';

@Injectable()
export class ClaimsService {
  constructor(
    @InjectRepository(DeviceClaimEntity)
    private readonly claimsRepository: Repository<DeviceClaimEntity>,
    @InjectRepository(DeviceEntity)
    private readonly devicesRepository: Repository<DeviceEntity>,
  ) {}

  async claimDevice(user: UserEntity, dto: ClaimDeviceDto) {
    const claim = await this.claimsRepository.findOne({
      where: {
        claimCode: dto.claimCode,
        device: { deviceId: dto.deviceId },
      },
      relations: ['device', 'claimedByUser'],
    });

    if (!claim) {
      throw new NotFoundException('Invalid device claim');
    }

    if (claim.claimedByUser && claim.claimedByUser.id !== user.id) {
      throw new ConflictException('Device already claimed');
    }

    claim.claimedByUser = user;
    claim.claimedAt = new Date();
    await this.claimsRepository.save(claim);

    claim.device.owner = user;
    claim.device.name = dto.name?.trim() || claim.device.name;
    await this.devicesRepository.save(claim.device);

    return {
      deviceId: claim.device.deviceId,
      name: claim.device.name,
      claimCode: claim.claimCode,
      claimedAt: claim.claimedAt,
    };
  }
}

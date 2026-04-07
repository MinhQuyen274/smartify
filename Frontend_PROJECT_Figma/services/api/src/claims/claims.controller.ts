import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { ClaimsService } from './claims.service';
import { JwtAuthGuard } from '../shared/guards/jwt-auth.guard';
import { CurrentUser } from '../shared/decorators/current-user.decorator';
import { RequestUser } from '../shared/types/request-user';
import { ClaimDeviceDto } from './dto/claim-device.dto';
import { UserEntity } from '../auth/user.entity';

@Controller('devices')
@UseGuards(JwtAuthGuard)
export class ClaimsController {
  constructor(private readonly claimsService: ClaimsService) {}

  @Post('claim')
  claim(@CurrentUser() user: RequestUser, @Body() dto: ClaimDeviceDto) {
    const currentUser = { id: user.sub, email: user.email } as UserEntity;
    return this.claimsService.claimDevice(currentUser, dto);
  }
}

import { Controller, Get, Param, Query, UseGuards } from '@nestjs/common';
import { DevicesService } from './devices.service';
import { JwtAuthGuard } from '../shared/guards/jwt-auth.guard';
import { CurrentUser } from '../shared/decorators/current-user.decorator';
import { RequestUser } from '../shared/types/request-user';
import { DeviceHistoryQueryDto } from './dto/device-history-query.dto';

@Controller('devices')
@UseGuards(JwtAuthGuard)
export class DevicesController {
  constructor(private readonly devicesService: DevicesService) {}

  @Get()
  list(@CurrentUser() user: RequestUser) {
    return this.devicesService.listForUser(user.sub);
  }

  @Get(':deviceId')
  detail(@Param('deviceId') deviceId: string, @CurrentUser() user: RequestUser) {
    return this.devicesService.getDeviceDetail(deviceId, user.sub);
  }

  @Get(':deviceId/live')
  live(@Param('deviceId') deviceId: string, @CurrentUser() user: RequestUser) {
    return this.devicesService.getLiveSnapshot(deviceId, user.sub);
  }

  @Get(':deviceId/history')
  history(
    @Param('deviceId') deviceId: string,
    @Query() query: DeviceHistoryQueryDto,
    @CurrentUser() user: RequestUser,
  ) {
    return this.devicesService.getHistory(deviceId, user.sub, query);
  }
}

import { Body, Controller, Param, Post, UseGuards } from '@nestjs/common';
import { CommandsService } from './commands.service';
import { JwtAuthGuard } from '../shared/guards/jwt-auth.guard';
import { PowerCommandDto } from './dto/power-command.dto';
import { CurrentUser } from '../shared/decorators/current-user.decorator';
import { RequestUser } from '../shared/types/request-user';
import { UserEntity } from '../auth/user.entity';

@Controller('devices')
@UseGuards(JwtAuthGuard)
export class CommandsController {
  constructor(private readonly commandsService: CommandsService) {}

  @Post(':deviceId/commands/power')
  power(
    @Param('deviceId') deviceId: string,
    @Body() dto: PowerCommandDto,
    @CurrentUser() user: RequestUser,
  ) {
    const currentUser = { id: user.sub, email: user.email } as UserEntity;
    return this.commandsService.sendPowerCommand(deviceId, dto.relayOn, currentUser);
  }
}

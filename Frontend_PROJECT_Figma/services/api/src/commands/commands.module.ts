import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DeviceCommandEntity } from './device-command.entity';
import { CommandsController } from './commands.controller';
import { CommandsService } from './commands.service';
import { DevicesModule } from '../devices/devices.module';
import { MqttModule } from '../mqtt/mqtt.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([DeviceCommandEntity]),
    DevicesModule,
    MqttModule,
  ],
  controllers: [CommandsController],
  providers: [CommandsService],
})
export class CommandsModule {}

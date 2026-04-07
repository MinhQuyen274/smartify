import { IsBoolean } from 'class-validator';

export class PowerCommandDto {
  @IsBoolean()
  relayOn!: boolean;
}

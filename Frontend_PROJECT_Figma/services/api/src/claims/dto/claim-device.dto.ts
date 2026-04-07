import { IsOptional, IsString, MaxLength } from 'class-validator';

export class ClaimDeviceDto {
  @IsString()
  deviceId!: string;

  @IsString()
  claimCode!: string;

  @IsOptional()
  @IsString()
  @MaxLength(120)
  name?: string;
}

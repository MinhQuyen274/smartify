import { IsIn, IsOptional, IsString } from 'class-validator';

const intervals = ['raw', 'minute', 'hour', 'day'] as const;

export class DeviceHistoryQueryDto {
  @IsOptional()
  @IsString()
  from?: string;

  @IsOptional()
  @IsString()
  to?: string;

  @IsOptional()
  @IsIn(intervals)
  interval?: (typeof intervals)[number];
}

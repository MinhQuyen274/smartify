import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ReportsService } from './reports.service';
import { JwtAuthGuard } from '../shared/guards/jwt-auth.guard';
import { CurrentUser } from '../shared/decorators/current-user.decorator';
import { RequestUser } from '../shared/types/request-user';
import { ReportRangeDto } from './dto/report-range.dto';

@Controller('reports')
@UseGuards(JwtAuthGuard)
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  @Get('summary')
  summary(@CurrentUser() user: RequestUser, @Query() query: ReportRangeDto) {
    return this.reportsService.getSummary(user.sub, query.from, query.to);
  }
}

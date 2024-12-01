import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Schedule } from './schedule.entity';
import { Doctor } from '../user/doctor/doctor.entity';
import { ScheduleController } from './schedule.controller';
import { ScheduleService } from './schedule.service';


@Module({
  imports: [TypeOrmModule.forFeature([Schedule, Doctor])],
  controllers: [ScheduleController],
  providers: [ScheduleService],
  exports: [TypeOrmModule], // Export TypeOrmModule to provide repositories
})
export class ScheduleModule {}


import { Controller, Post, Body, Get, Param, Put, Delete, Session,Request, BadRequestException,Headers } from '@nestjs/common';
import { ScheduleService } from './schedule.service';
import { Schedule } from './schedule.entity';
import * as jwt from 'jsonwebtoken';  // Import jsonwebtoken for JWT creation
import { JwtService } from '@nestjs/jwt';  // Import JwtService if using JWT for token validation


@Controller('schedules')
export class ScheduleController {
  constructor(private readonly scheduleService: ScheduleService) {}

  // Create a new schedule for the logged-in doctor
  @Post()
  async create(
    @Body('day') day: string,
    @Body('time') time: number,
    @Session() session: any,
  ): Promise<Schedule> {
    return this.scheduleService.create(day, time, session);
  }

  // Create multiple schedules for the logged-in doctor
  @Post('bulk')
  async createBulk(
    @Body() payload: { id_doc: number; schedules: { day: string; time: number }[] }, // Accepting id_doc and schedules
  ): Promise<Schedule[]> {
    const { id_doc, schedules } = payload;

    if (!id_doc) {
      throw new BadRequestException('Doctor ID is required');
    }

    if (!schedules || !Array.isArray(schedules) || schedules.length === 0) {
      throw new BadRequestException('Schedules are required and must be a non-empty array');
    }

    // Pass the doctor ID and schedules to the service
    return this.scheduleService.createBulk(schedules, id_doc);
  }
  // Get a specific schedule by ID
  @Get(':id_sche')
  async findOne(
    @Param('id_sche') id_sche: number,
    @Session() session: any,
  ): Promise<Schedule> {
    return this.scheduleService.findOne(id_sche, session);
  }

  // Update a schedule for the logged-in doctor by schedule ID
  @Put(':id_sche')
  async update(
    @Param('id_sche') id_sche: number,
    @Body('day') day: string,
    @Body('time') time: number,
    @Session() session: any,
  ): Promise<Schedule> {
    return this.scheduleService.update(id_sche, day, time, session);
  }

  // Delete a schedule for the logged-in doctor by schedule ID
  @Delete(':id_sche')
  async remove(@Param('id_sche') id_sche: number, @Session() session: any): Promise<void> {
    return this.scheduleService.remove(id_sche, session);
  }
}

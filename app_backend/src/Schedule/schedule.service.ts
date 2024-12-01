import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Schedule } from './schedule.entity';
import { Doctor } from '../user/doctor/doctor.entity';
import { BadRequestException } from '@nestjs/common';

@Injectable()
export class ScheduleService {
  constructor(
    @InjectRepository(Schedule)
    private scheduleRepository: Repository<Schedule>,
    @InjectRepository(Doctor)
    private doctorRepository: Repository<Doctor>,
  ) {}

  // Create a new schedule (doctorId is taken from the session)
  async create(day: string, time: number, session: any): Promise<Schedule> {
    const doctorId = session.doctorId;

    if (!doctorId) {
      throw new BadRequestException('Doctor not logged in');
    }

    // Ensure the doctor exists
    const doctor = await this.doctorRepository.findOne({ where: { id_doc: doctorId } });
    if (!doctor) {
      throw new BadRequestException('Doctor not found');
    } 

    const schedule = new Schedule();
    schedule.day = day;
    schedule.time = time;
    schedule.id_doc = doctorId; // Associate the schedule with the logged-in doctor

    return this.scheduleRepository.save(schedule);
  }

  // Create multiple schedules for the logged-in doctor
  async createBulk(schedules: { day: string; time: number }[], doctorId: number): Promise<Schedule[]> {
    const doctor = await this.doctorRepository.findOne({ where: { id_doc: doctorId } });
    if (!doctor) {
      throw new BadRequestException('Doctor not found');
    }

    const scheduleEntities = schedules.map(scheduleData => {
      const schedule = new Schedule();
      schedule.day = scheduleData.day;
      schedule.time = scheduleData.time;
      schedule.id_doc = doctorId; // Associate the schedule with the logged-in doctor
      return schedule;
    });

    // Bulk insert the schedules into the database
    return this.scheduleRepository.save(scheduleEntities);
  }
  // Get all schedules for the logged-in doctor
  async findByDoctor(session: any): Promise<Schedule[]> {
    const doctorId = session.doctorId;

    if (!doctorId) {
      throw new BadRequestException('Doctor not logged in');
    }

    return this.scheduleRepository.find({ where: { id_doc: doctorId } });
  }

  // Get a specific schedule by its ID, ensuring it's the logged-in doctor's schedule
  async findOne(id_sche: number, session: any): Promise<Schedule> {
    const doctorId = session.doctorId;

    if (!doctorId) {
      throw new BadRequestException('Doctor not logged in');
    }

    const schedule = await this.scheduleRepository.findOne({ where: { id_sche, id_doc: doctorId } });
    if (!schedule) {
      throw new BadRequestException('Schedule not found or you do not have access');
    }

    return schedule;
  }

  // Update a schedule by ID, ensuring it's the logged-in doctor's schedule
  async update(id_sche: number, day: string, time: number, session: any): Promise<Schedule> {
    const doctorId = session.doctorId;

    if (!doctorId) {
      throw new BadRequestException('Doctor not logged in');
    }

    const schedule = await this.scheduleRepository.findOne({ where: { id_sche, id_doc: doctorId } });
    if (!schedule) {
      throw new BadRequestException('Schedule not found or you do not have access');
    }

    schedule.day = day;
    schedule.time = time;
    

    return this.scheduleRepository.save(schedule);
  }

  // Delete a schedule by ID, ensuring it's the logged-in doctor's schedule
  async remove(id_sche: number, session: any): Promise<void> {
    const doctorId = session.doctorId;

    if (!doctorId) {
      throw new BadRequestException('Doctor not logged in');
    }

    const schedule = await this.scheduleRepository.findOne({ where: { id_sche, id_doc: doctorId } });
    if (!schedule) {
      throw new BadRequestException('Schedule not found or you do not have access');
    }

    await this.scheduleRepository.delete(id_sche);
  }
}

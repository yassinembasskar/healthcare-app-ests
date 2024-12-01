import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Appointment } from './appointment.entity';
import { Schedule } from 'src/Schedule/schedule.entity';

@Injectable()
export class AppointmentService {
  constructor(
    @InjectRepository(Schedule)
    private scheduleRepository: Repository<Schedule>,
    
    @InjectRepository(Appointment)
    private readonly appointmentRepository: Repository<Appointment>,
  ) {}

  // Create a new appointment
  async create(appointment: Partial<Appointment>): Promise<Appointment> {
    const newAppointment = this.appointmentRepository.create(appointment);
    return this.appointmentRepository.save(newAppointment);
  }

  
  async scheduleAppointment(data: {
    day: string;
    time: number;
    doctorId: number;
  }): Promise<Appointment> {
    const { day, time, doctorId } = data;

    // Validate the day string
    const validDays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    if (!validDays.includes(day)) {
      throw new BadRequestException(`Invalid day: ${day}. Must be one of: ${validDays.join(', ')}`);
    }

    // Calculate the appointment date based on the current week
    const today = new Date();
    const currentDayIndex = today.getDay(); // 0 (Sunday) to 6 (Saturday)
    const targetDayIndex = validDays.indexOf(day);

    const daysDifference = targetDayIndex - currentDayIndex;
    const appointmentDate = new Date(today);
    appointmentDate.setDate(today.getDate() + daysDifference); // Adjust to the correct day in the current week
    appointmentDate.setHours(0, 0, 0, 0); // Reset time

    // Convert to ISO string for database comparison
    const appointmentDateString = appointmentDate.toISOString().split('T')[0];

    // Fetch the doctor's schedule for the specified day
    const doctorSchedule = await this.scheduleRepository.find({
      where: { id_doc: doctorId, day },
    });

    // Validate that the chosen time matches the doctor's schedule
    const isTimeAvailableInSchedule = doctorSchedule.some((schedule) => schedule.time === time);
    if (!isTimeAvailableInSchedule) {
      throw new BadRequestException(`Doctor is not available at ${time} on ${day}.`);
    }

    // Check if the time slot is already booked
    const overlappingAppointment = await this.appointmentRepository.findOne({
      where: {
        id_doc: doctorId,
        appointmentdate: appointmentDateString,
        starttime: time,
      },
    });

    if (overlappingAppointment) {
      throw new BadRequestException(`The time slot starting at ${time} is already booked.`);
    }

    // Save the appointment
    const newAppointment = this.appointmentRepository.create({
      appointmentdate: appointmentDateString,
      starttime: time,
      endtime: time + 1, // End time is 1 hour after start time
      id_doc: doctorId,
    });

    return this.appointmentRepository.save(newAppointment);
  }
  

  // Get all appointments
  async findAll(): Promise<Appointment[]> {
    return this.appointmentRepository.find({
      relations: ['doctor', 'patient'], // Include related entities in the query
    });
  }

  // Get a single appointment by ID
  async findOne(id_app: number): Promise<Appointment> {
    return this.appointmentRepository.findOne({
      where: { id_app },
      relations: ['doctor', 'patient'], // Include related entities
    });
  }

  // Update an appointment by ID
  async update(id_app: number, updateData: Partial<Appointment>): Promise<Appointment> {
    await this.appointmentRepository.update(id_app, updateData);
    return this.findOne(id_app);
  }

  // Delete an appointment by ID
  async delete(id_app: number): Promise<void> {
    await this.appointmentRepository.delete(id_app);
  }

  // Get appointments for a specific doctor
  async findByDoctorId(doctorId: number): Promise<Appointment[]> {
    return this.appointmentRepository.find({
      where: { doctor: { id_doc: doctorId } },
      relations: ['doctor', 'patient'], // Include related entities
    });
  }
}

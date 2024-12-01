import { Controller, Get, Post, Put, Delete, Param, Body, Session, BadRequestException } from '@nestjs/common';
import { AppointmentService } from './appointment.service';
import { Appointment } from './appointment.entity';

@Controller('appointments')
export class AppointmentController {
  constructor(private readonly appointmentService: AppointmentService) {}

  // Create a new appointment
  @Post()
  async create(@Body() appointment: Partial<Appointment>): Promise<Appointment> {
    return this.appointmentService.create(appointment);
  }

  @Post('schedule')
  async scheduleAppointment(@Body() body: any) {
    const { day, time, doctorId } = body;

    if (!day || time === undefined || !doctorId) {
      throw new BadRequestException('All fields (day, time, doctorId) are required.');
    }

    return this.appointmentService.scheduleAppointment({
      day,
      time: Number(time),
      doctorId: Number(doctorId),
    });
  }

  // Get all appointments
  @Get()
  async findAll(): Promise<Appointment[]> {
    return this.appointmentService.findAll();
  }

  // Get a single appointment by ID
  @Get(':id')
  async findOne(@Param('id') id: number): Promise<Appointment> {
    return this.appointmentService.findOne(id);
  }

  // Update an appointment by ID
  @Put(':id')
  async update(
    @Param('id') id: number,
    @Body() updateData: Partial<Appointment>,
  ): Promise<Appointment> {
    return this.appointmentService.update(id, updateData);
  }

  // Delete an appointment by ID
  @Delete(':id')
  async delete(@Param('id') id: number): Promise<void> {
    return this.appointmentService.delete(id);
  }

  
  @Get('doctor/my-appointments')
  async findMyAppointments(@Session() session: any): Promise<Appointment[]> {
    const id_doc = session.doctorId;

    if (!id_doc) {
      throw new Error('No doctor is logged in.');
    }

    return this.appointmentService.findByDoctorId(id_doc); 
  }
}

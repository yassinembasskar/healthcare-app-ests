import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  Session,
  BadRequestException,
  Query,
} from '@nestjs/common';
import { DoctorService } from './doctor.service';
import { Doctor } from './doctor.entity';

@Controller('doctors')
export class DoctorController {
  constructor(private readonly doctorService: DoctorService) {}

  // Get all doctors
  @Get()
  async findAll(): Promise<Doctor[]> {
    return this.doctorService.findAll();
  }

  @Get('filter-by-speciality')
  async filterBySpeciality(@Query('speciality') speciality: string): Promise<Doctor[]> {
    return this.doctorService.filterBySpeciality(speciality);
  }

  // Get a single doctor by ID
  @Get(':id')
  async findOne(@Param('id') id: number): Promise<Doctor> {
    return this.doctorService.findOne(id);
  }

  // Create a new doctor
  @Post()
  async create(@Body() doctor: Partial<Doctor>): Promise<Doctor> {
    return this.doctorService.create(doctor);
  }

  // Update an existing doctor
  @Put(':id')
  async update(@Param('id') id: number, @Body() doctor: Partial<Doctor>): Promise<Doctor> {
    return this.doctorService.update(id, doctor);
  }

  // Delete a doctor
  @Delete(':id')
  async remove(@Param('id') id: number): Promise<void> {
    return this.doctorService.remove(id);
  }

  // Seed example doctors
  @Post('seed')
  async seedDoctors(): Promise<Doctor[]> {
    return this.doctorService.seedDoctors();
  }

  // Sign up (Create an account)
  @Post('signup')
  async signUp(
    @Body()
    body: {
      username_doc: string;
      password_doc: string;
      fullname_doc: string;
      gender_doc: string;
      speciality: string;
      cabinet_add: string;
      email: string;
      phone_number: string;
    }
  ): Promise<Doctor> {
    const {
      username_doc,
      password_doc,
      fullname_doc,
      gender_doc,
      speciality,
      cabinet_add,
      email,
      phone_number,
    } = body;
  
    // Pass the data to the service for creation
    return this.doctorService.create({
      username_doc,
      password_doc,
      fullname_doc,
      gender_doc,
      speciality,
      cabinet_add,
      email,
      phone_number,
    });
  }
   


  // Login (Authenticate a doctor)
  @Post('login')
  async login(
    @Body() body: { email: string; password_doc: string },
    @Session() session: any
  ): Promise<Doctor> {
    const { email, password_doc } = body;

    // Validate login credentials
    const doctor = await this.doctorService.login(email, password_doc);

    if (!doctor) {
      throw new BadRequestException('Invalid email or password');
    }

    // Store the doctor's ID in the session
    session.doctorId = doctor.id_doc;

    // Return the authenticated doctor
    return doctor;
  }

  // Logout (Clear session)
  @Post('logout')
  logout(@Session() session: any): string {
    session.doctorId = null;
    return 'Logged out successfully';
  }

  // Check authentication status
  @Post('check')
  checkAuth(@Session() session: any): string {
    if (session.doctorId) {
      return `Doctor with ID ${session.doctorId} is logged in`;
    }
    return 'No doctor logged in';
  }
  
}

import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcryptjs';
import { Doctor } from './doctor.entity';

@Injectable()
export class DoctorService {
  constructor(
    @InjectRepository(Doctor)
    private doctorRepository: Repository<Doctor>,  // Injecting the doctor repository
  ) {}

  // Method to get all doctors
  async findAll(): Promise<Doctor[]> {
    return this.doctorRepository.find();
  }

  // Filter doctors by speciality
  async filterBySpeciality(speciality: string): Promise<Doctor[]> {
    return this.doctorRepository.find({
      where: { speciality },
    });
  }

  // Method to get a doctor by id
  async findOne(id_doc: number): Promise<Doctor> {
    return this.doctorRepository.findOne({ where: { id_doc } });
  }

  async findOneByUsername(email: string): Promise<Doctor | undefined> {
    const Doctor = this.doctorRepository.findOne({ where: { email } })
    return Doctor;
}

  // Method to create a new doctor (Sign up)
  async create(doctor: Partial<Doctor>): Promise<Doctor> {
    if (doctor.password_doc) {
      // Hash the password before saving
      doctor.password_doc = await this.hashPassword(doctor.password_doc);
    }
  
    // Create and save the new doctor
    const newDoctor = this.doctorRepository.create(doctor);
    return this.doctorRepository.save(newDoctor);
  }

  // Method to update an existing doctor
  async update(id_doc: number, doctor: Partial<Doctor>): Promise<Doctor> {
    if (doctor.password_doc) {
      doctor.password_doc = await this.hashPassword(doctor.password_doc);  // Ensure password is hashed if updated
    }
    await this.doctorRepository.update(id_doc, doctor);
    return this.doctorRepository.findOne({ where: { id_doc } });
  }

  // Method to delete a doctor
  async remove(id: number): Promise<void> {
    await this.doctorRepository.delete(id);
  }

  // Method to handle login (Authenticate doctor with email and password)
  async login(email: string, password_doc: string): Promise<Doctor | null> {
    const doctor = await this.doctorRepository.findOne({ where: { email } });

    if (doctor) {
      const isPasswordValid = await bcrypt.compare(password_doc, doctor.password_doc);
      if (isPasswordValid) {
        return doctor;
      } 
    }
    return null;
  }

  // Utility function to hash passwords
  private async hashPassword(password: string): Promise<string> {
    return bcrypt.hash(password, 10);  // Hash with 10 rounds of salting
  }

  // Seed doctors with example data
  async seedDoctors(): Promise<Doctor[]> {
    const doctors = [
      {
        username_doc: 'johnsmith',
        password_doc: 'securepassword1',
        fullname_doc: 'Dr. John Smith',
        gender_doc: 'Male',
        profilpic_doc: 'https://example.com/johnsmith.jpg',
        speciality: 'Cardiology',
        cabinet_add: '123 Heart Lane',
        email: 'john.smith@example.com',
        phone_number: '1234567890',
      },
      {
        username_doc: 'janedoe',
        password_doc: 'securepassword2',
        fullname_doc: 'Dr. Jane Doe',
        gender_doc: 'Female',
        profilpic_doc: 'https://example.com/janedoe.jpg',
        speciality: 'Pediatrics',
        cabinet_add: '456 Childcare Street',
        email: 'jane.doe@example.com',
        phone_number: '0987654321',
      },
      {
        username_doc: 'alanbrown',
        password_doc: 'securepassword3',
        fullname_doc: 'Dr. Alan Brown',
        gender_doc: 'Male',
        profilpic_doc: 'https://example.com/alanbrown.jpg',
        speciality: 'Neurology',
        cabinet_add: '789 Brain Avenue',
        email: 'alan.brown@example.com',
        phone_number: '1122334455',
      },
      {
        username_doc: 'clarawilson',
        password_doc: 'securepassword4',
        fullname_doc: 'Dr. Clara Wilson',
        gender_doc: 'Female',
        profilpic_doc: 'https://example.com/clarawilson.jpg',
        speciality: 'Orthopedics',
        cabinet_add: '321 Joint Way',
        email: 'clara.wilson@example.com',
        phone_number: '2233445566',
      },
      {
        username_doc: 'emilydavis',
        password_doc: 'securepassword5',
        fullname_doc: 'Dr. Emily Davis',
        gender_doc: 'Female',
        profilpic_doc: 'https://example.com/emilydavis.jpg',
        speciality: 'Dermatology',
        cabinet_add: '654 Skin Clinic Road',
        email: 'emily.davis@example.com',
        phone_number: '3344556677',
      },
    ];

    // Hash the passwords before saving
    const hashedDoctors = await Promise.all(
      doctors.map(async (doctor) => ({
        ...doctor,
        password_doc: await this.hashPassword(doctor.password_doc),
      }))
    );

    // Save the hashed doctors to the database
    return this.doctorRepository.save(hashedDoctors);
  }

  
}

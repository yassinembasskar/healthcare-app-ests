import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('doctor') // Matches the table name
export class Doctor {
  @PrimaryGeneratedColumn()
  id_doc: number; // Auto-generated ID
 
  @Column({ type: 'text', nullable: false })
  username_doc: string; // Username

  @Column({ type: 'text', nullable: false })
  password_doc: string; // Password

  @Column({ type: 'text', nullable: false })
  fullname_doc: string; // Full Name

  @Column({ type: 'text', nullable: true })
  gender_doc: string; // Gender (nullable)

  @Column({ type: 'text', nullable: true })
  profilpic_doc: string; // Profile Picture URL

  @Column({ type: 'text', nullable: true })
  speciality: string; // Speciality (nullable)

  @Column({ type: 'text', nullable: true })
  cabinet_add: string; // Cabinet Address (nullable)

  @Column({ type: 'text', nullable: false })
  email: string; // Email Address

  @Column({ type: 'text', nullable: false })
  phone_number: string; // Phone Number
}

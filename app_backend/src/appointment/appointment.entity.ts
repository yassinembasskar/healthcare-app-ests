import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Doctor } from '../user/doctor/doctor.entity'; // Import the Doctor entity

@Entity('appointment')
export class Appointment {
  @PrimaryGeneratedColumn()
  id_app: number; // Appointment ID

  @Column({ type: 'date', nullable: false })
  appointmentdate: string; // Date of appointment

  @Column({ type: 'int', nullable: false })
  starttime: number; // Start time (e.g., as an integer for hours or minutes)

  @Column({ type: 'int', nullable: false })
  endtime: number; // End time

  // Relationship with the Doctor entity
  @ManyToOne(() => Doctor, (doctor) => doctor.id_doc, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'id_doc' }) // Matches the column name in the table
  doctor: Doctor;

  @Column()
  id_doc: number;

  /*// Relationship with the Patient entity
  @ManyToOne(() => Patient, (patient) => patient.id_patient, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'id_patient' }) // Matches the column name in the table
  patient: Patient;*/
}

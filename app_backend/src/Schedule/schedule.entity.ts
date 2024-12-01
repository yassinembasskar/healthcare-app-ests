// schedule.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Doctor } from '../user/doctor/doctor.entity';

@Entity('schedule')
export class Schedule {
  @PrimaryGeneratedColumn()
  id_sche: number;

  @Column({ type: 'varchar', length: 20 })
  day: string;

  @Column()
  time: number;

  // Relationship with the Doctor entity
  @ManyToOne(() => Doctor, (doctor) => doctor.id_doc, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'id_doc' }) // Matches the column name in the table
  doctor: Doctor;

  @Column()
  id_doc: number;
}

import { User } from 'src/user/patient/user.entity';
import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, ManyToOne, JoinColumn, OneToMany  } from 'typeorm';
import { ExtractionEntity } from './extraction.entity';

@Entity({ name: 'LabTest' })
export class LabTestEntity {
  @PrimaryGeneratedColumn()
  test_id: number;

  @ManyToOne(() => User, user => user.labTests, {onDelete: 'CASCADE', eager: true })
  @JoinColumn({ name: 'patient_id' }) 
  patient: User;

  @Column({ length: 255 })
  test_name: string;

  @CreateDateColumn({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  test_date: Date;

  @OneToMany(() => ExtractionEntity, extraction => extraction.test)
  extractions: ExtractionEntity[];
}

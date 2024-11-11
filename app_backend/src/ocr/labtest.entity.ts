import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn  } from 'typeorm';

@Entity({name:'LabTest'})
export class LabTestEntity {
  @PrimaryGeneratedColumn()
  test_id: number;

  @Column()
  id_patient: number;

  @Column()
  test_name: string;

  @CreateDateColumn ({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  test_date: Date;
}

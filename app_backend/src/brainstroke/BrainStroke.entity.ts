import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity({name:'BrainStroke_prediction'})
export class BrainStroke {
  @PrimaryGeneratedColumn({ })
  BrainStroke_prediction_id: number;

  @Column({})
  id_patient: number;

  @Column({ default: null })
  hypertension?: boolean;

  @Column({ default: null })
  heart_disease?: boolean;

  @Column({ default: null })
  ever_married?: string;

  @Column({ default: null })
  work_type?: string;

  @Column({ default: null })
  residence_type?: string;

  @Column({ type: 'float' ,default: null })
  avg_glucose_level?: number;

  @Column({ type: 'float' ,default: null })
  bmi?: number;
  
  @Column({ default: null })
  smoking_status?: string;
}
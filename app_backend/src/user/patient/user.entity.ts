import { Unique, Entity, Column, PrimaryGeneratedColumn, OneToMany } from 'typeorm';
import { IsEmail, IsString, MinLength, MaxLength, IsDateString } from 'class-validator';
import { LabTestEntity } from 'src/ocr/labtest.entity';
import { HeartFailure } from 'src/heartfailure/HeartFailure.entity';
import { BrainStroke } from 'src/brainstroke/BrainStroke.entity';

@Entity({ name: 'patient' })
@Unique(['email']) 
@Unique(['fullName']) 
export class User {
  @PrimaryGeneratedColumn()
  idPatient: number;

  @Column({ length: 100, nullable: false })
  @IsEmail()
  email: string;

  @Column({ length: 60, nullable: false })
  @IsString()
  @MinLength(8, { message: 'Password must be at least 6 characters long' })
  password: string;

  @Column({ length: 50, nullable: false })
  @IsString()
  fullName: string;

  @Column({ type: 'date', nullable: false })
  @IsDateString()
  birthday: Date;

  @Column({ length: 6, nullable: false })
  @IsString()
  @MaxLength(6)
  gender: string;

  @Column({ nullable: false })
  height: number;
  
  @Column({ nullable: false })
  weight: number;

  @OneToMany(() => LabTestEntity, labTest => labTest.patient)
  labTests: LabTestEntity[];

  @OneToMany(() => HeartFailure, heartFailure => heartFailure.patient)
  heartFailures: HeartFailure[];

  @OneToMany(() => BrainStroke, brainStroke => brainStroke.patient)
  brainStrokes: BrainStroke[];
}
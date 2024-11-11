import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity({name:'patient'})
export class User {
  @PrimaryGeneratedColumn({ })
  idPatient: number;

  @Column({ length: 100 })
  email: string;

  @Column({ length: 60 })
  password: string;

  @Column({ length: 50 })
  fullName: string;

  @Column({ type: 'date' })
  birthday: Date;

  @Column({ length: 6 })
  gender: string;

  @Column()
  height: number;

  @Column()
  weight: number;
}
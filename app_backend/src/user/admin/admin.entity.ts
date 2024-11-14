import { Unique ,Entity, Column, PrimaryGeneratedColumn } from 'typeorm';
import { IsEmail } from 'class-validator';

@Entity({ name: 'admin' })
@Unique(['email'])
@Unique(['username'])
export class admin {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ nullable: false })
  username: string;

  @Column({ nullable: false })
  @IsEmail()  // Validates that the value is a valid email format
  email: string;

  @Column({ nullable: false })
  password: string;
}
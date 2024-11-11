import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity({name:'admin'})
export class admin {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  username: string;

  @Column()
  email: string;

  @Column()
  password: string;
}

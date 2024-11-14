import { User } from 'src/user/patient/user.entity';
import { Entity, Column, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';

@Entity({name:'HeartFailure_prediction'})
export class HeartFailure {
  @PrimaryGeneratedColumn({ })
  HearthFailure_prediction_id: number;

  @ManyToOne(() => User, user => user.heartFailures, { nullable: false }) // Set cascade if necessary
  patient: User;

  @Column({ default: null })
  anaemia: number;

  @Column({default: null })
  diabetes: number;

  @Column({ type: 'float' , default: null  })
  creatinine_phosphokinase: number    ;

  @Column({default: null})
  high_blood_pressure: number;

  @Column({ type: 'float'  ,default: null})
  platelets:  number;

  @Column({ type: 'float'  ,default: null})
  serum_creatinine: number;

  @Column({ type: 'float' ,default: null  })
  serum_sodium: number;

  @Column({default: null})
  smoking: number;

  @Column({default: null})
  time: number;
}
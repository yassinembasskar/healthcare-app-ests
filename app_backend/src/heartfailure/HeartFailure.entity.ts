import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity({name:'HeartFailure_prediction'})
export class HeartFailure {
  @PrimaryGeneratedColumn({ })
  HearthFailure_prediction_id: number;

  @Column({})
  id_patient: number;

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
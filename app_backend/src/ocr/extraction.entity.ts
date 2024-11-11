import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity({name:'extractions'})
export class ExtractionEntity {
  @PrimaryGeneratedColumn()
  id_extractions: number;

  @Column()
  test_id: number;

  @Column()
  name_substance?: string;

  @Column()
  value_substance: string;

  @Column({default: '--'})
  mesure_substance?: string = '--';

  @Column({default: 'unidentified'})
  interpretation: string; 
}

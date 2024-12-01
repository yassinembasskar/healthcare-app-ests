import { Entity, Column, PrimaryGeneratedColumn, JoinColumn, ManyToOne } from 'typeorm';
import { LabTestEntity } from './labtest.entity';
import { AdditionalInfo } from './additionalInfos.interface';

@Entity({name:'extractions'})
export class ExtractionEntity {
  @PrimaryGeneratedColumn()
  id_extractions: number;

  @ManyToOne(() => LabTestEntity, labTest => labTest.extractions, { eager: true })
  @JoinColumn({ name: 'test_id' })
  test: LabTestEntity;

  @Column({ nullable: true })
  name_substance?: string;

  @Column()
  value_substance: string;

  @Column({ default: '--', nullable: true })
  mesure_substance?: string;

  @Column({ default: 'unidentified' })
  interpretation: string;

  @Column()
  needed: Boolean;

  @Column({nullable: true})
  explanation: string;

  @Column({ type: 'jsonb', nullable: true })
  additional_info: AdditionalInfo;
}

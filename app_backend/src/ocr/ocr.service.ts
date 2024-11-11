// ocr.service.ts
import { ConsoleLogger, Injectable } from '@nestjs/common';
import * as childProcess from 'child_process';
import { promisify } from 'util';
import { User } from 'src/user/user.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LabTestEntity } from './labtest.entity';
import { ExtractionEntity } from './extraction.entity';
import { BrainStroke } from 'src/brainstroke/BrainStroke.entity';
import { HeartFailure } from 'src/heartfailure/HeartFailure.entity';
import { promises } from 'dns';


const exec = promisify(childProcess.exec);

@Injectable()
export class OcrService {

  constructor(
    @InjectRepository(LabTestEntity)
    private readonly labtestRepository: Repository<LabTestEntity>,
    @InjectRepository(ExtractionEntity)
    private readonly extractionRepository: Repository<ExtractionEntity>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(BrainStroke)
    private readonly brainstrokeRepository: Repository<BrainStroke>,
    @InjectRepository(HeartFailure)
    private readonly heartfailureRepository: Repository<HeartFailure>,   
      
  ){}   
  async processImage(imagePath: string, id: number): Promise<{labtest: LabTestEntity,  extractions: ExtractionEntity[] }> {
    try {
      const patient = await this.userRepository.findOne({ where: { idPatient : id } });
      const gender = patient.gender;
      const age = this.calculateAge(patient.birthday);
      const { stdout, stderr } = await exec(`python decryption.py ${imagePath} ${gender} ${age}`);
      if (stderr) { 
        throw new Error(stderr);
    }
    console.log(stdout)
      var ocrResults = stdout.trim(); 
      console.log(ocrResults)
      ocrResults = ocrResults.substring(2, ocrResults.length - 2);
      var results = ocrResults.split('}, {');
      var correctedResults = results.map(result => result.replace(/'/g, '"'));
      const labtestCount = await this.labtestRepository.count({ where: { id_patient: id } });
      console.log(patient.idPatient);
      const labtest = await this.labtestRepository.create({
        id_patient: patient.idPatient,
        test_date: new Date(),
        test_name: `Labtest ${labtestCount + 1}`,
      });
      console.log('ID Patient:', labtest.id_patient);
      console.log(labtest);
      const extractions: ExtractionEntity[] = [];
      for(const result of correctedResults)  {
        const dataArray = JSON.parse(`{${result}}`);
        const extraction = this.extractionRepository.create({
          test_id: -1,
          name_substance: dataArray.identifiant,
          value_substance: dataArray.value,
          mesure_substance: dataArray.mesurement,
          interpretation: dataArray.interpretation,
        });
        extractions.push(extraction);
        
      }
      return {labtest, extractions};
    }catch (error) {
      console.error('Error processing image:', error);
      throw error; // Re-throw the error to be handled by the caller
    }
    
  }

  private calculateAge(birthday: Date): number { 
    const birthDate = new Date(birthday);
    const currentDate = new Date();

    let age = currentDate.getFullYear() - birthDate.getFullYear();
    const monthDifference = currentDate.getMonth() - birthDate.getMonth();

    if (monthDifference < 0 || (monthDifference === 0 && currentDate.getDate() < birthDate.getDate())) {
      age--;
    }

    return age;
  }
  async  saveTests(labtest: LabTestEntity,  extractions: ExtractionEntity[] ): Promise<void> {
    const brainStroke = await this.brainstrokeRepository.findOne({ where: { id_patient: labtest.id_patient } });
    const heartFailure = await this.heartfailureRepository.findOne({ where: { id_patient: labtest.id_patient } });
    const savedLabtest = await this.labtestRepository.save(labtest);
    console.log("the labtest saved seccessfully");
    await Promise.all(extractions.map(async (extraction) => {
      extraction.test_id = savedLabtest.test_id;
      if (extraction.name_substance.toLowerCase().includes('glycem') || extraction.name_substance.toLowerCase().includes('glucose') ) {
        console.log("saved glucose");
        console.log("saved diabetes");
        const floated_value = parseFloat(extraction.value_substance);
        if (isNaN(floated_value)) {
          console.log('an error with value of glucose');
        } else {
          brainStroke.avg_glucose_level = floated_value;
        }
        if (extraction.interpretation == 'high'){
          heartFailure.diabetes = 1;
        } else {
          heartFailure.diabetes = 0;
        }
      }
      if (extraction.name_substance.toLowerCase().includes('platelet')) {
        console.log("saved platelets");
        const int_value = parseInt(extraction.value_substance);
        if (isNaN(int_value)) {
          console.log('an error with value of platelet');
        } else {
          heartFailure.platelets = int_value; 
        }
      }
      if (extraction.name_substance.toLowerCase().includes('cpk') || extraction.name_substance.toLowerCase().includes('creatinine phosphokinase')) {
        console.log("saved cpk");
        const int1_value = parseFloat(extraction.value_substance);
        if (isNaN(int1_value)) {
          console.log('an error with value of cpk');
        } else {
          heartFailure.creatinine_phosphokinase = int1_value; 
        } 
      } else if (extraction.name_substance.toLowerCase().includes('creatinine')){
        console.log("saved creatinine");
        const int2_value = parseFloat(extraction.value_substance);
        if (isNaN(int2_value)) {
          console.log('an error with value of creatinine');
        } else {
          heartFailure.serum_creatinine = int2_value; 
        }
      }
      if (extraction.name_substance.toLowerCase().includes('sodium')) {
        console.log("saved sodium");
        const int3_value = parseFloat(extraction.value_substance);
        if (isNaN(int3_value)) {
          console.log('an error with value of sodium');
        } else {
          heartFailure.serum_sodium = int3_value; 
        } 
      }
      if (extraction.name_substance.toLowerCase().includes('hemoglobine')) {
        console.log("saved anemia");
        if (extraction.interpretation == 'low'){
          heartFailure.anaemia = 1;
        } else {
          heartFailure.anaemia = 0;
        }
      }
      await this.heartfailureRepository.save(heartFailure);
      await this.brainstrokeRepository.save(brainStroke);
      return await this.extractionRepository.save(extraction);
    }));
    console.log("the extractions are successfully saved");

  }

  async getlabtestbyuserid(id_patient:number):Promise<LabTestEntity[]>{
    return this.labtestRepository.find({where : {id_patient}})

  }

  async getextractionsbytestid(test_id : number):Promise<ExtractionEntity[]>{
    return this.extractionRepository.find({where:{test_id}})
  }
}


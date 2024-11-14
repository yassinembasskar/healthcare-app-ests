// ocr.service.ts
import { Injectable } from '@nestjs/common';
import * as childProcess from 'child_process';
import { promisify } from 'util';
import { User } from 'src/user/patient/user.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LabTestEntity } from './labtest.entity';
import { ExtractionEntity } from './extraction.entity';
import { BrainStroke } from 'src/brainstroke/BrainStroke.entity';
import { HeartFailure } from 'src/heartfailure/HeartFailure.entity';


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

      //here we execute the python code
      const patient = await this.userRepository.findOne({ where: { idPatient : id } });
      const gender = patient.gender;
      const age = this.calculateAge(patient.birthday);
      const { stdout, stderr } = await exec(`python decryption.py ${imagePath} ${gender} ${age}`);
      if (stderr) { 
        throw new Error(stderr);
      }

      //here we extract entities from output
      var ocrResults = stdout.trim(); 
      ocrResults = ocrResults.substring(2, ocrResults.length - 2);
      var results = ocrResults.split('}, {');
      var correctedResults = results.map(result => result.replace(/'/g, '"'));


      const labtestCount = await this.labtestRepository.count({ where: { patient } });
      const labtest = await this.labtestRepository.create({
        patient: patient,
        test_date: new Date(),
        test_name: `Labtest ${labtestCount + 1}`,
      });

      const extractions: ExtractionEntity[] = [];
      for(const result of correctedResults)  {
        const dataArray = JSON.parse(`{${result}}`);
        const extraction = this.extractionRepository.create({
          test: null,
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
    const brainStroke = await this.brainstrokeRepository.findOne({ where: { patient: labtest.patient } });
    const heartFailure = await this.heartfailureRepository.findOne({ where: { patient: labtest.patient } });
    const savedLabtest = await this.labtestRepository.save(labtest);
    
    await Promise.all(extractions.map(async (extraction) => {
      extraction.test = savedLabtest;
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

  async getlabtestbyuserid(idPatient:number):Promise<LabTestEntity[]>{
    const patient = await this.userRepository.findOne({ where :{idPatient} });
    return this.labtestRepository.find({where : {patient}})
  }

  async getextractionsbytestid(test_id : number):Promise<ExtractionEntity[]>{
    const test = await this.labtestRepository.findOne({ where :{test_id} });
    return this.extractionRepository.find({where:{test}})
  }
}


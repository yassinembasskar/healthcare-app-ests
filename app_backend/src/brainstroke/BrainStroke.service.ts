
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { BrainStroke } from './BrainStroke.entity';
import { BrainStrokeDTO } from './BrainStroke.dto';
import * as path from 'path';
import { exec } from 'child_process';
import { stdout } from 'process';
import { UserService } from 'src/user/user.service';
import { stringify } from 'querystring';


@Injectable()
export class BrainStrokeService {

    constructor(
        @InjectRepository(BrainStroke)
        private readonly BrainStrokeRepository: Repository<BrainStroke>,
        private readonly userService: UserService , 
    ) {}

    async getpredictioncomponenetsbyuserid(id_patient:number):Promise<BrainStroke|null>{
        
        
        return this.BrainStrokeRepository.findOne({where:{id_patient}}) ;
    }

    async saveComponents(brainStrokeDTO: BrainStrokeDTO): Promise<BrainStroke> {
        console.log(brainStrokeDTO);
        
        const id_patient =  brainStrokeDTO.id_patient  ; 
        console.log(id_patient)
        const existingRecord = await this.BrainStrokeRepository.findOne({where :{ id_patient :brainStrokeDTO.id_patient }});
        console.log('service')
        console.log(existingRecord)
        if (existingRecord) {
         
          existingRecord.hypertension = brainStrokeDTO.hypertension;
          existingRecord.heart_disease = brainStrokeDTO.heart_disease;
          existingRecord.ever_married = brainStrokeDTO.ever_married;
          existingRecord.work_type = brainStrokeDTO.work_type;
          existingRecord.residence_type = brainStrokeDTO.residence_type;
          existingRecord.avg_glucose_level = brainStrokeDTO.avg_glucose_level;
          existingRecord.bmi = brainStrokeDTO.bmi;
          existingRecord.smoking_status = brainStrokeDTO.smoking_status;

          
      
          console.log(' saved' )
          return this.BrainStrokeRepository.save(existingRecord);
        } else {
          console.log('didnt save' )
          return this.BrainStrokeRepository.save(brainStrokeDTO);

        }
      }
        

      async getpredictionbyuserid(id_patient:number):Promise<any>{
        const BR = this.BrainStrokeRepository.findOne({where :{ id_patient }});
        const user = this.userService.getuserbyid(id_patient);
        const gender : string = (await user).gender; 
        const age : string = calculateAge((await user).birthday).toString() ; 
        const hypertension : string = (await BR).hypertension.toString(); 
        const heart_disease : string = (await BR).heart_disease.toString(); 
        const ever_married : string = (await BR).ever_married ; 
        const work_type : string =(await BR).work_type ; 
        const Residence_type : string = (await BR).residence_type ; 
        const avg_glucose_level : string = (await BR).avg_glucose_level.toString(); 
        const bmi : string = (await BR).bmi.toString(); 
        
        const smoking_status : string = (await BR).smoking_status; 
        
        return this.processAndRunScript([gender,age,hypertension,heart_disease,ever_married,work_type,Residence_type,avg_glucose_level,bmi,smoking_status]);
      }

      async processAndRunScript(values: string[]): Promise<any> {
        const transformedValues = this.transformCategoricalToNumbers(...values);
        return this.runPythonScript('brainstroke.py', transformedValues.map(String));
    }

      private transformCategoricalToNumbers(...values: string[]): number[] {
        const CSV_COLUMN_NAMES = ['gender','age', 'hypertension', 'heart_disease', 'ever_married','work_type',
         'Residence_type','avg_glucose_level', 'bmi','smoking_status'];

        const categoricalMappings = {
            'gender': {'Female': 0, 'Male': 1},
            'ever_married': {'No': 0, 'Yes': 1},
            'hypertension': {'false': 0, 'true': 1},
            'heart_disease': {'false': 0, 'true': 1},
            'work_type': {'Private': 1, 'Govt_job': 0, 'children': 3, 'Self-employed': 2},
            'Residence_type': {'Urban': 1, 'Rural': 0},
            'smoking_status': {'never smoked': 2, 'smokes': 3, 'Unknown': 0, 'formerly smoked': 1}
        };
        const transformedValues: number[] = [];
        for (let i = 0; i < values.length; i++) {
            const columnName = CSV_COLUMN_NAMES[i];
            const value = values[i];
            
            
            if (categoricalMappings.hasOwnProperty(columnName) && typeof value === 'string') {
                const mapping = categoricalMappings[columnName];
                transformedValues.push(mapping[value] !== undefined ? mapping[value] : NaN);
            } else {
                
                transformedValues.push(parseFloat(value));
            }
        }
        console.log(transformedValues)
        return transformedValues;
    }


      
  async runPythonScript(scriptName: string, args?: string[]): Promise<string|null|any> {

    return new Promise((resolve, reject) => {
      const { exec } = require('child_process');
      const argsString = args ? args.join(' ') : '';
      const command = `python src\\brainstroke\\brainstroke.py ${argsString}`;
      console.log({argsString})
  
      exec(command, (error, stdout, stderr) => {
        if (error) {
          console.log(`error: ${error.message}`);
          reject(error.message);
        }
        else if (stderr) {
          console.log(`stderr: ${stderr}`);
          reject(stderr); 
        }
        else {
          console.log(stdout);
          resolve(stdout.trim()); 
        }
      });
    });
  }
   
}

function calculateAge(birthday: Date): number {
  const today = new Date();
  const birthDate = new Date(birthday);

  let age = today.getFullYear() - birthDate.getFullYear();
  const monthDiff = today.getMonth() - birthDate.getMonth();

  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
      age--;
  }

  return age;
}

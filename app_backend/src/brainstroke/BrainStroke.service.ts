
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { BrainStroke } from './BrainStroke.entity';
import { BrainStrokeDTO } from './BrainStroke.dto';
import * as path from 'path';
import { spawn } from 'child_process';
import { UserService } from 'src/user/patient/user.service';


@Injectable()
export class BrainStrokeService {

    constructor(
        @InjectRepository(BrainStroke)
        private readonly BrainStrokeRepository: Repository<BrainStroke>,
        private readonly userService: UserService , 
    ) {}

    async getpredictioncomponenetsbyuserid(id_patient:number):Promise<BrainStroke|null>{
        const patient = await this.userService.getUserById(id_patient);
        return this.BrainStrokeRepository.findOne({where:{patient}}) ;
    }

    async saveComponents(brainStrokeDTO: BrainStrokeDTO): Promise<BrainStroke> {
        const existingRecord = await this.BrainStrokeRepository.findOne({ where: { patient: brainStrokeDTO.patient } });
        if (existingRecord) {
            Object.assign(existingRecord, brainStrokeDTO);
            return this.BrainStrokeRepository.save(existingRecord);
        } else {
            return this.BrainStrokeRepository.save(brainStrokeDTO);
        }
      }
        

      async getpredictionbyuserid(id_patient:number):Promise<any>{
        const patient = await this.userService.getUserById(id_patient);
        const brainStrokeData = await this.BrainStrokeRepository.findOne({ where: { patient } });
        const user = await this.userService.getUserById(id_patient);
        const userValues = [
            user.gender,
            calculateAge(user.birthday).toString(),
            brainStrokeData?.hypertension.toString(),
            brainStrokeData?.heart_disease.toString(),
            brainStrokeData?.ever_married,
            brainStrokeData?.work_type,
            brainStrokeData?.residence_type,
            brainStrokeData?.avg_glucose_level.toString(),
            brainStrokeData?.bmi.toString(),
            brainStrokeData?.smoking_status
        ];
        return this.processAndRunScript(userValues);
      }

      async processAndRunScript(values: string[]): Promise<any> {
        const transformedValues = this.transformCategoricalToNumbers(...values);
        return await this.runPythonScript('brainstroke.py', transformedValues);
      }

      private transformCategoricalToNumbers(...values: string[]): number[] {

        const categoricalMappings = {
            gender: { 'Female': 0, 'Male': 1 },
            ever_married: { 'No': 0, 'Yes': 1 },
            hypertension: { 'false': 0, 'true': 1 },
            heart_disease: { 'false': 0, 'true': 1 },
            work_type: { 'Private': 1, 'Govt_job': 0, 'children': 3, 'Self-employed': 2 },
            Residence_type: { 'Urban': 1, 'Rural': 0 },
            smoking_status: { 'never smoked': 2, 'smokes': 3, 'Unknown': 0, 'formerly smoked': 1 }
        };

        return values.map((value, i) => {
            const columnName = Object.keys(categoricalMappings)[i];
            if (categoricalMappings[columnName] && categoricalMappings[columnName][value] !== undefined) {
                return categoricalMappings[columnName][value];
            }
            return parseFloat(value);
        });

        /*
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
        */
    }


      
  async runPythonScript(scriptName: string, args?: number[]): Promise<string|null|any> {
        const scriptPath = path.resolve(__dirname, '../../src/brainstroke/', scriptName);
        return new Promise((resolve, reject) => {
            const pythonProcess = spawn('python', [scriptPath, ...args.map(String)]);
            let output = '';
            pythonProcess.stdout.on('data', (data) => {
                output += data.toString();
            });
            pythonProcess.stderr.on('data', (data) => {
                reject(data.toString());
            });
            pythonProcess.on('close', () => resolve(output.trim()));
        });
    /*
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
    */
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

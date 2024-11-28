
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
          try {
            const patient = await this.userService.getUserById(id_patient);
            if (!patient) {
              throw new Error(`User with ID ${id_patient} not found.`);
            }
            // Retrieve brain stroke data for the patient
            const brainStrokeData = await this.BrainStrokeRepository.findOne({ where: { patient } });
            if (!brainStrokeData) {
              throw new Error(`Brain stroke data for user with ID ${id_patient} not found.`);
            }
        
            const age = calculateAge(patient.birthday);
            if (isNaN(age)) {
              throw new Error('Invalid birthday format. Unable to calculate age.');
            }
        
            const userValues = [
              patient.gender || 'unknown',
              age.toString(),
              brainStrokeData.hypertension?.toString() || '0',
              brainStrokeData.heart_disease?.toString() || '0',
              brainStrokeData.ever_married || 'unknown',
              brainStrokeData.work_type || 'unknown',
              brainStrokeData.residence_type || 'unknown',
              brainStrokeData.avg_glucose_level?.toString() || '0.0',
              brainStrokeData.bmi?.toString() || '0.0',
              brainStrokeData.smoking_status || 'unknown'
            ];
        
            const hasIncompleteInfo = userValues.some(value => value === '0' || value === 'unknown' || value === null || value === undefined);
            if (hasIncompleteInfo) {
              throw new Error('All fields must be filled with valid information.');

            }
        
            return await this.processAndRunScript(userValues);
        
          } catch (error) {
            console.error('Error processing brain stroke data:', error);
            throw new Error('Failed to process brain stroke data. Please ensure all required information is filled and try again.');
          }
        }

      async processAndRunScript(values: string[]): Promise<any> {
        const transformedValues = this.transformCategoricalToNumbers(...values);
        return await this.runPythonScript('brainstroke.py', transformedValues);
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
        return transformedValues;
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

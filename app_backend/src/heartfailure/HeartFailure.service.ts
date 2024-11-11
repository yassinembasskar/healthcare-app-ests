// user.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { HeartFailure } from './HeartFailure.entity';
import { HeartFailureDTO } from './HeartFailure.dto';
import * as path from 'path';
import { exec } from 'child_process';
import { UserService } from 'src/user/user.service';


@Injectable()
export class HeartFailureService {

    constructor(
        @InjectRepository(HeartFailure)
        private readonly HeartFailureRepository: Repository<HeartFailure>,
        private readonly userService: UserService , 
    ) {}

    
    async getpredictioncomponenetsbyuserid(id_patient:number):Promise<HeartFailure|null>{
        
        
        return this.HeartFailureRepository.findOne({where:{id_patient}}) ;
    }

    async saveComponents(HeartFailureDTO: HeartFailureDTO): Promise<HeartFailure> {
        const id_patient =  HeartFailureDTO.id_patient  ; 
        const existingRecord = await this.HeartFailureRepository.findOne({where :{ id_patient }});
        
        if (existingRecord) {

            existingRecord.anaemia = HeartFailureDTO.anaemia;
            existingRecord.diabetes = HeartFailureDTO.diabetes;
            existingRecord.creatinine_phosphokinase = HeartFailureDTO.creatinine_phosphokinase;
            existingRecord.high_blood_pressure = HeartFailureDTO.high_blood_pressure;
            existingRecord.platelets = HeartFailureDTO.platelets;
            existingRecord.serum_creatinine = HeartFailureDTO.serum_creatinine;
            existingRecord.serum_sodium = HeartFailureDTO.serum_sodium;
            existingRecord.time = HeartFailureDTO.time  ;
            existingRecord.smoking = HeartFailureDTO.smoking  ;
      
          
          return this.HeartFailureRepository.save(existingRecord);
        } else {
          
          return this.HeartFailureRepository.save(HeartFailureDTO);
        }
      }

      async getpredictionbyuserid(id_patient : number):Promise<any>{
        const user = this.userService.getuserbyid(id_patient);
        const HF = this.HeartFailureRepository.findOne({where:{id_patient}});
        var gender  = 1; 
        if ((await user).gender = "Female")  gender = 0 ; 
        const age  = calculateAge((await user).birthday) ; 
        const diabetes = (await HF).diabetes  ; 
        const anaemia = (await HF).anaemia ; 
        const creatinine_phosphokinase = (await HF).creatinine_phosphokinase ; 
        const high_blood_pressure = (await HF).high_blood_pressure;
        const platelets = (await HF).platelets ; 
        const serum_creatinine = (await HF).serum_creatinine ; 
        const serum_sodium = (await HF).serum_sodium ; 
        const smoking = (await HF).smoking ; 
        const time = (await HF).time ; 

        return this.runPythonScript('heartfailure.py',[age,anaemia,creatinine_phosphokinase , diabetes , high_blood_pressure
          ,platelets , serum_creatinine,serum_sodium, gender,smoking,time])
      }




      async runPythonScript(scriptName: string, args?: any[]): Promise<string | null> {
        return new Promise((resolve, reject) => {
          const { exec } = require('child_process');
          const argsString = args ? args.join(' ') : '';
          const command = `python src\\heartfailure\\heartfailure.py ${argsString}`;
          console.log('args')
          console.log({ argsString })
      
          exec(command, (error, stdout, stderr) => {
            if (error) {     
              console.log(`error: ${error.message}`);
              reject(error.message); 
            } else if (stderr) {
              console.log(`stderr: ${stderr}`);
              reject(stderr); 
            } else {
              console.log(stdout);
              const trimmedOutput = stdout.trim();
              resolve(trimmedOutput);
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

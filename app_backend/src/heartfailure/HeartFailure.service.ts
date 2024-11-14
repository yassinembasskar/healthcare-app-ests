// user.service.ts
import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { HeartFailure } from './HeartFailure.entity';
import { HeartFailureDTO } from './HeartFailure.dto';
import { UserService } from 'src/user/patient/user.service';


@Injectable()
export class HeartFailureService {

    constructor(
        @InjectRepository(HeartFailure)
        private readonly heartFailureRepository: Repository<HeartFailure>,
        private readonly userService: UserService , 
    ) {}

    
    async getpredictioncomponenetsbyuserid(id_patient:number):Promise<HeartFailure|null>{
      try {
        return await this.heartFailureRepository.findOne({ where: { patient: { idPatient: id_patient } } });
    } catch (error) {
        throw new InternalServerErrorException('Failed to retrieve prediction components');
    }
    }

    async saveComponents(heartFailureDTO: HeartFailureDTO): Promise<HeartFailure> {
          try {
              const { patient } = heartFailureDTO;
              const existingRecord = await this.heartFailureRepository.findOne({ where: { patient } });

              if (existingRecord) {
                  Object.assign(existingRecord, heartFailureDTO); // Update existing record fields
                  return await this.heartFailureRepository.save(existingRecord);
              } else {
                  const newRecord = this.heartFailureRepository.create(heartFailureDTO);
                  return await this.heartFailureRepository.save(newRecord);
              }
          } catch (error) {
              throw new InternalServerErrorException('Failed to save heart failure components');
          }   
      }

      async getpredictionbyuserid(id_patient : number):Promise<any>{
        const patient = await this.userService.getUserById(id_patient);
        const HF = await this.heartFailureRepository.findOne({ where: { patient } });
        var gender  = 1; 
        if ((patient).gender = "Female")  gender = 0 ; 
        const age  = calculateAge((patient).birthday) ; 
        const diabetes = (HF).diabetes  ; 
        const anaemia = (HF).anaemia ; 
        const creatinine_phosphokinase = (HF).creatinine_phosphokinase ; 
        const high_blood_pressure = (HF).high_blood_pressure;
        const platelets = (HF).platelets ; 
        const serum_creatinine = (HF).serum_creatinine ; 
        const serum_sodium = (HF).serum_sodium ; 
        const smoking = (HF).smoking ; 
        const time = (HF).time ; 

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

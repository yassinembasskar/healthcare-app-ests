// user.service.ts
import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
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
            const existingRecord = await this.heartFailureRepository.findOne({ where: { patient: heartFailureDTO.patient } });
            if (existingRecord) {
                Object.assign(existingRecord, heartFailureDTO); 
                return await this.heartFailureRepository.save(existingRecord);
            } else {
                return await this.heartFailureRepository.save(heartFailureDTO);
            }
        } catch (error) {
        console.error('Error processing heart failure data:', error);

        // Re-throw with a user-friendly message
        if (error['statusCode']) {
            throw new Error(`${error.message}`);
        } else {
            throw new Error('Failed to process heart failure data. Please ensure all required information is filled and try again.');
        }
    }  
    }

    async getpredictionbyuserid(id_patient: number): Promise<any> {
        try {
            const patient = await this.userService.getUserById(id_patient);
            if (!patient) {
              throw new NotFoundException(`User not found.`);
            }
            const heartFailureData = await this.heartFailureRepository.findOne({ where: { patient } });
            if (!heartFailureData) {
                throw new NotFoundException(`Heart failure data for user not found.`);
            }
            const gender = patient.gender === "Female" ? 0 : 1;
            const age = calculateAge(patient.birthday);
            if (isNaN(age)) {
                throw new BadRequestException('Invalid birthday format. Unable to calculate age.');
            }
            const userValues = [
                age,
                heartFailureData.anaemia?.toString(),
                heartFailureData.creatinine_phosphokinase?.toString(),
                heartFailureData.diabetes?.toString(),
                heartFailureData.high_blood_pressure?.toString(),
                heartFailureData.platelets?.toString() || null,
                heartFailureData.serum_creatinine?.toString(),
                heartFailureData.serum_sodium?.toString(),
                gender.toString(),
                heartFailureData.smoking?.toString(),
                heartFailureData.time?.toString()
            ];
            const hasIncompleteInfo = userValues.some(value => value === null || value === undefined);
            if (hasIncompleteInfo) {
                throw new BadRequestException('All fields must be filled with valid information.');
            }
            return this.runPythonScript(userValues);
        } catch (error) {
            throw error;
        }
    }

    async runPythonScript(args?: any[]): Promise<string | null> {
      return new Promise((resolve, reject) => {
          try {
              const { exec } = require('child_process');
              const argsString = args ? args.join(' ') : '';
              const command = `python src\\heartfailure\\heartfailure.py ${argsString}`;
              exec(command, (error, stdout, stderr) => {
                  if (error) {
                      reject(new Error(`Execution error: ${error.message}`));
                  } else if (stderr) {
                      reject(new Error(`Script error: ${stderr.trim()}`));
                  } else {
                      resolve(stdout.trim());
                  }
              });
          } catch (err) {
              reject(new Error(`Unexpected error: ${err instanceof Error ? err.message : String(err)}`));
          }
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

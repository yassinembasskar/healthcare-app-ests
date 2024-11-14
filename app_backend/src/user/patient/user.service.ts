import { Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Admin, Repository } from 'typeorm';
import { User } from './user.entity';
import * as bcrypt from 'bcrypt';
import { InvalidEmailException } from 'src/exceptions/invalid-email.exception';
import { EmailAlreadyExist } from 'src/exceptions/email-exist.exception';
import { FullNameAlreadyExist } from 'src/exceptions/fullname-exist.exception';
import { InvalidPassword } from 'src/exceptions/password-incorrect.exception';
import { NotSecurePassword } from 'src/exceptions/passwordnotsecure.exception';
import { HeartFailure } from 'src/heartfailure/HeartFailure.entity';
import { BrainStroke } from 'src/brainstroke/BrainStroke.entity';
import { admin } from '../admin/admin.entity';


@Injectable()
export class UserService {
    constructor(
        @InjectRepository(User)
        private readonly userRepository: Repository<User>,
        @InjectRepository(admin)
        private readonly adminRepository: Repository<admin>,
        @InjectRepository(HeartFailure)
        private readonly heartFailureRepository: Repository<HeartFailure>,
        @InjectRepository(BrainStroke)
        private readonly brainStrokeRepository: Repository<BrainStroke>,
    ) {}

    async findOneByEmail(email: string): Promise<User | undefined> {
      const user = await this.userRepository.findOne({ where: { email } });
      return user;
  }

    async updatePassword(idPatient: number, oldPassword: string, newPassword: string): Promise<void> {
      const existingUser = await this.userRepository.findOne({ where: { idPatient } });
  
      if (!bcrypt.compare(oldPassword, existingUser.password)) {
        throw new InvalidPassword();
      }
      
      if (!newPassword || newPassword.length < 8) {
        throw new NotSecurePassword();
      }
  
      const hashedPassword = await bcrypt.hash(newPassword, 10);
      existingUser.password = hashedPassword;
      await this.userRepository.save(existingUser);
    }

    async updateInfos(user:User): Promise<User>{
      try {
        const emailAdmin = await this.adminRepository.findOne({ where :{email: user.email} });
        if(emailAdmin){
          throw new EmailAlreadyExist();
        }

        const fullNameAdmin = await this.adminRepository.findOne({ where :{username: user.fullName} });
        if(fullNameAdmin){
          throw new FullNameAlreadyExist();
        }

        const existingUser = await this.userRepository.findOne({ where: { idPatient: user.idPatient } });
        if (!existingUser) {
          throw new NotFoundException(`User with ID ${user.idPatient} not found`); // User not found
        }

        existingUser.fullName = user.fullName;
        existingUser.email = user.email;
        existingUser.birthday = user.birthday;
        existingUser.height = user.height;
        existingUser.weight = user.weight;
        existingUser.gender = user.gender;
        try {
          await this.userRepository.save(existingUser);
        } catch (error) {
          throw new InternalServerErrorException('An error occurred while saving the user data');
        }
        return existingUser;

      } catch (error) {
        
        if (error instanceof EmailAlreadyExist || error instanceof FullNameAlreadyExist) {
          throw error;
        }
        throw new InternalServerErrorException('An unexpected error occurred during the update process');
      }
  }

    async createUser(user: User): Promise<User> {
        try {

            const hashedPassword = await bcrypt.hash(user.password, 10);
            
            const fullNameAdmin = await this.adminRepository.findOne({ where :{username: user.fullName} });
            const emailAdmin = await this.adminRepository.findOne({ where :{email: user.email} });
            if(emailAdmin){
              throw new EmailAlreadyExist();
            }
            if(fullNameAdmin){
              throw new FullNameAlreadyExist();
            }

            user.password = hashedPassword;

            const newUser = this.userRepository.create(user);
            const savedUser = await this.userRepository.save(newUser);
            
            const heartfailure = this.heartFailureRepository.create({
              patient: newUser,
            });

            const brainstroke = this.brainStrokeRepository.create({
              patient: newUser,
              bmi: newUser.weight / (newUser.height * newUser.height),
            });

            await this.heartFailureRepository.save(heartfailure);
            await this.brainStrokeRepository.save(brainstroke);
            return savedUser;
        } catch (error) {
          if (error instanceof EmailAlreadyExist || error instanceof FullNameAlreadyExist) {
            throw error;
          }
          throw new InternalServerErrorException('An error occurred while creating the user');
        }
      }
      
      async getUserById(idPatient: number): Promise<User> {
        try {
          const user = await this.userRepository.findOne({ where: { idPatient } });
          if (!user) throw new NotFoundException('User not found');
          return user;
        } catch (error) {
          throw new InternalServerErrorException('An error occurred while retrieving user by ID');
        }
      }
      

    async getallusers():Promise<User[]>{
      return this.userRepository.find();
    }
    
    async deleteuser(idPatient:number):Promise<any>{
      return this.userRepository.delete({idPatient});
    }
}



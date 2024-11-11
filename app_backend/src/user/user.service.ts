
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';
import { throwIfEmpty } from 'rxjs';
import * as bcrypt from 'bcrypt';
import { ExceptionsHandler } from '@nestjs/core/exceptions/exceptions-handler';
import { InvalidEmailException } from 'src/exceptions/invalid-email.exception';
import { EmailAlreadyExist } from 'src/exceptions/email-exist.exception';
import { FullNameAlreadyExist } from 'src/exceptions/fullname-exist.exception';
import { InvalidPassword } from 'src/exceptions/password-incorrect.exception';
import { NotSecurePassword } from 'src/exceptions/passwordnotsecure.exception';
import { HeartFailure } from 'src/heartfailure/HeartFailure.entity';
import { BrainStroke } from 'src/brainstroke/BrainStroke.entity';


@Injectable()
export class UserService {

    constructor(
        @InjectRepository(User)
        private readonly userRepository: Repository<User>,
        @InjectRepository(HeartFailure)
        private readonly heartFailureRepository: Repository<HeartFailure>,
        @InjectRepository(BrainStroke)
        private readonly brainStrokeRepository: Repository<BrainStroke>,
    ) {}

    async findOneByUsername(email: string): Promise<User | undefined> {
      const user = this.userRepository.findOne({ where: { email } }) ;
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

      const existingUser = await this.userRepository.findOne({ where :{idPatient: user.idPatient} });
      console.log("existing user id: "+existingUser.idPatient);
      console.log("user id: "+user.idPatient);
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(user.email)) {
        throw new InvalidEmailException();
      }
      const emailUser = await this.userRepository.findOne({ where :{email: user.email} });
      const loginUser = await this.userRepository.findOne({ where :{fullName: user.fullName} });
      if(existingUser.email != user.email && emailUser){
        console.log(existingUser.email);
        console.log(user.email);
        throw new EmailAlreadyExist();
      }
      if(existingUser.fullName != user.fullName && loginUser){
        console.log(existingUser.fullName);
        console.log(user.fullName);
        throw new FullNameAlreadyExist();
      }
      if (existingUser) {
        existingUser.fullName = user.fullName;
        existingUser.email = user.email;
        existingUser.birthday = user.birthday;
        existingUser.height = user.height;
        existingUser.weight = user.weight;
        existingUser.gender = user.gender;
        await this.userRepository.save(existingUser);
        console.log('User has been updated:');
        console.log('full name :', existingUser.fullName);
        return existingUser;
      } else {
        console.log("this user does not exist");
        return null;
      }
  }

    async createUser(user: User): Promise<User> {
        
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        // Check if the email is valid
        if (!emailRegex.test(user.email)) {
          throw new InvalidEmailException();
        }

        const hashedPassword = await bcrypt.hash(user.password, 10);
        
        const emailUser = await this.userRepository.findOne({ where :{email: user.email} });
        const loginUser = await this.userRepository.findOne({ where :{fullName: user.fullName} });
        if(emailUser){
          throw new EmailAlreadyExist();
        }
        if(loginUser){
          throw new FullNameAlreadyExist();
        }

        user.password = hashedPassword;

        const newUser = this.userRepository.create(user);
        const savedUser = await this.userRepository.save(newUser);
        
        const heartfailure = this.heartFailureRepository.create({
          id_patient: newUser.idPatient,
        });
        const brainstroke = this.brainStrokeRepository.create({
          id_patient: newUser.idPatient,
          bmi: (newUser.weight / newUser.height * newUser.height),
        });
        await this.heartFailureRepository.save(heartfailure);
        await this.brainStrokeRepository.save(brainstroke);
        
        console.log('New user has been added:');
        console.log('full name :', savedUser.fullName);
    
        return savedUser;
      }
    async getuserbyid(idPatient : number):Promise<User>{
      console.log('service')
      console.log(idPatient);
      const user = this.userRepository.findOne({ where: {idPatient } }) ;
      console.log(user)
      return user 
    }

    async getallusers():Promise<User[]>{
      return this.userRepository.find();
    }
    async deleteuser(idPatient:number):Promise<any>{
      return this.userRepository.delete({idPatient});
    }
}



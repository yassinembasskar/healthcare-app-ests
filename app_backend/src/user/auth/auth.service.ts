import { Injectable, NotFoundException } from '@nestjs/common';
import { UserService } from '../patient/user.service';
import { User } from '../patient/user.entity';
import * as bcrypt from 'bcrypt';
import { AdminService } from '../admin/admin.service';
import { admin } from '../admin/admin.entity';
import { InvalidPassword } from 'src/exceptions/password-incorrect.exception';
import { EmailDoesNotExist } from 'src/exceptions/emailnotexist.exception';
import { InvalidCredantials } from 'src/exceptions/invalid-credantials.exception';
import { Doctor } from '../doctor/doctor.entity';
import { DoctorService } from '../doctor/doctor.service';


  
@Injectable()
export class AuthService {
  constructor(private userService: UserService,
              private DoctorService: DoctorService,
            ) {}

  async validateUserEmail(email: string, password: string): Promise<User|Doctor> {
    const [user, Doctor] = await Promise.all([
      this.userService.findOneByEmail(email),
      this.DoctorService.findOneByUsername(email),
    ]);

    if (user) {
      if(await bcrypt.compare(password, user.password)){
        return user;
      }  
    }else if (Doctor){
      if(await bcrypt.compare(password, Doctor.password_doc)){
        return Doctor;
      } else {
        throw new InvalidPassword();
      }
    } else {
      throw new EmailDoesNotExist();
    } 
  }

  async validateUserId(userId: number, password: string, role: string): Promise<User|Doctor> {
    let user = null;
    let Doctor = null;
    if (role = "patient") {user = await this.userService.getUserById(userId);}
    else if (role = "admin"){Doctor = await this.DoctorService.findOne(userId);}
    else {throw new NotFoundException();}
    
    if (user && role == 'patient') {
      if(password == user.password){
        return user;
      }  
    }else if (Doctor && role == 'Doctor'){
      if(password == Doctor.password_doc){
        return Doctor;
      } else {
        throw new InvalidCredantials();
      }
    } 
  }
}
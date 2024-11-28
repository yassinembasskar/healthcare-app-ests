import { Injectable, NotFoundException } from '@nestjs/common';
import { UserService } from '../patient/user.service';
import { User } from '../patient/user.entity';
import * as bcrypt from 'bcrypt';
import { AdminService } from '../admin/admin.service';
import { admin } from '../admin/admin.entity';
import { InvalidPassword } from 'src/exceptions/password-incorrect.exception';
import { EmailDoesNotExist } from 'src/exceptions/emailnotexist.exception';
import { InvalidCredantials } from 'src/exceptions/invalid-credantials.exception';

  
@Injectable()
export class AuthService {
  constructor(private userService: UserService,
              private adminservice: AdminService,
            ) {}

  async validateUserEmail(email: string, password: string): Promise<User|admin> {
    const [user, admin] = await Promise.all([
      this.userService.findOneByEmail(email),
      this.adminservice.findOneByUsername(email),
    ]);

    if (user) {
      if(await bcrypt.compare(password, user.password)){
        return user;
      }  
    }else if (admin){
      if(await bcrypt.compare(password, admin.password)){
        return admin;
      } else {
        throw new InvalidPassword();
      }
    } else {
      throw new EmailDoesNotExist();
    } 
  }

  async validateUserId(userId: number, password: string, role: string): Promise<User|admin> {
    let user = null;
    let admin = null;
    if (role = "patient") {user = await this.userService.getUserById(userId);}
    else if (role = "admin"){admin = await this.adminservice.getAdminById(userId);}
    else {throw new NotFoundException();}
    
    if (user && role == 'patient') {
      if(password == user.password){
        return user;
      }  
    }else if (admin && role == 'admin'){
      if(password == admin.password){
        return admin;
      } else {
        throw new InvalidCredantials();
      }
    } 
  }
}
import { Injectable } from '@nestjs/common';
import { UserService } from './user.service';
import { User } from './user.entity';
import * as bcrypt from 'bcrypt';
import { AdminService } from './admin.service';
import { admin } from './admin.entity';
import { InvalidPassword } from 'src/exceptions/password-incorrect.exception';
import { EmailDoesNotExist } from 'src/exceptions/emailnotexist.exception';

  
@Injectable()
export class AuthService {
  constructor(private userService: UserService,private adminservice: AdminService) {}

  async validateUser(email: string, password: string): Promise<User|admin> {
    const user = await this.userService.findOneByUsername(email);
    const admin = await this.adminservice.findOneByUsername(email);

    if (user) {
      if(bcrypt.compare(password, user.password)){
        return user;
      }  
    }else if (admin){
      if(bcrypt.checkpw(password, admin.password)){
        return admin;
      } else {
        throw new InvalidPassword();
      }
    } else {
      throw new EmailDoesNotExist()
    } 
}
}

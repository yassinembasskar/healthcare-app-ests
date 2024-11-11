import { Body, Controller, Post, Request, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { User } from './user.entity';
import { admin } from './admin.entity';
import { Double } from 'typeorm';


interface UserJson {
  fullname: string;
  email: string;
  password: string;

    birthday: Date;
    gender: string;
    height: Double;
    weight: Double; 

  role: string;
}

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  async login(@Body() body: { email: string; password: string }): Promise<any> {
    const { email, password } = body;
    const entity = await this.authService.validateUser(email, password);
    if (entity instanceof User) {
      
      console.log('Returned entity is  a User:', entity);
      const userJson1 = {
        fullname: entity.fullName,
        email: entity.email,
        idPatient: entity.idPatient,
        role: "user"
      };
      return userJson1; 
    } else if (entity instanceof admin) {
      
      console.log('Returned entity is an Admin: ', entity);
      const userJson = {
        fullname: entity.username,
        email: entity.email,
        role: 'admin'
      };
      return userJson ; 
    } else {
      console.log('Returned entity is neither a User nor an Admin');
    }
  }
}

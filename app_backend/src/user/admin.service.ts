import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { admin } from './admin.entity';
import { UserService } from './user.service';



@Injectable()
export class AdminService{

    constructor(
        @InjectRepository(admin)
        private readonly adminRepository: Repository<admin>,
    ) {}

    async findOneByUsername(email: string): Promise<admin | undefined> {
      const admin = this.adminRepository.findOne({ where: { email } })

        return admin;
      }
    async createUser(admin : admin): Promise<admin> {
      console.log('User have been added :');
          console.log('Username:', admin.username);
          console.log('Email:', admin.email);
          console.log('Password:', admin.password);
        return admin;
    }



}

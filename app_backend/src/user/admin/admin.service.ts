import { Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { admin } from './admin.entity';

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

    async createUser(admin: admin): Promise<admin> {
        try {
          
          return await this.adminRepository.save(admin);
        } catch (error) {
          throw new InternalServerErrorException('An error occurred while creating the user');
        }
      }

    async getAdminById(id: number): Promise<admin> {
      try {
        const user = await this.adminRepository.findOne({ where: { id } });
        if (!user) throw new NotFoundException('User not found');
        return user;
      } catch (error) {
        throw new InternalServerErrorException('An error occurred while retrieving user by ID');
      }
    }



}

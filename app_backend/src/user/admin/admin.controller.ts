import { Controller, Post, Body } from '@nestjs/common';
import { AdminService } from './admin.service';
import { CreateAdminDto } from './create-admin.dto'; // The DTO with validation
import { admin } from './admin.entity';
import * as bcrypt from 'bcrypt';

@Controller('users')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}
  @Post('create')
  async createAdmin(@Body() adminDto: CreateAdminDto): Promise<admin> {
    const hashedPassword = await bcrypt.hash(adminDto.password, 10); 

    const adminEntity = new admin();
    adminEntity.username = adminDto.username;
    adminEntity.email = adminDto.email;
    adminEntity.password = hashedPassword;

    return this.adminService.createUser(adminEntity);
  }
}

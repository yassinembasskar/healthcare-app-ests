import { Controller, Post, Body } from '@nestjs/common';
import { AdminService } from './admin.service';
import { admin } from './admin.entity';

@Controller('users')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}




}

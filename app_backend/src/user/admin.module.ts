import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './user.entity';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { AdminService } from './admin.service';
import { admin } from './admin.entity';
import { AdminController } from './admin.controller';
import { UserModule } from './user.module';
import { forwardRef } from '@nestjs/common';
@Module({
  imports: [
    
    TypeOrmModule.forFeature([admin]),
    
  ],
  controllers: [AdminController],
  providers: [AdminService],
  exports: [AdminService],
})
export class AdminModule {}

import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './user.entity';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { AdminService } from './admin.service';
import { admin } from './admin.entity';
import { AdminModule } from './admin.module';
import { forwardRef } from '@nestjs/common';
import { HeartFailure } from 'src/heartfailure/HeartFailure.entity';
import { BrainStroke } from 'src/brainstroke/BrainStroke.entity';
@Module({
  imports: [
    TypeOrmModule.forFeature([User, HeartFailure, BrainStroke]),

  ],
  controllers: [UserController],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}

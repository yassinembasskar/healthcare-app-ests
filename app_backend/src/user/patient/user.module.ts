import { forwardRef, Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './user.entity';
import { HeartFailure } from 'src/heartfailure/HeartFailure.entity';
import { BrainStroke } from 'src/brainstroke/BrainStroke.entity';
import { admin } from '../admin/admin.entity';
import { AdminModule } from '../admin/admin.module';
@Module({
  imports: [forwardRef(() => AdminModule),
    TypeOrmModule.forFeature([User, HeartFailure, BrainStroke, admin]),
  ],
  controllers: [UserController],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}

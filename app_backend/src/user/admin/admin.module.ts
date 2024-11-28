import { forwardRef, Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdminService } from './admin.service';
import { admin } from './admin.entity';
import { AdminController } from './admin.controller';
import { User } from '../patient/user.entity';
import { UserModule } from '../patient/user.module';
@Module({
  imports: [forwardRef(() => UserModule),
    TypeOrmModule.forFeature([admin,User]),
  ],
  controllers: [AdminController],
  providers: [AdminService],
  exports: [AdminService],
})
export class AdminModule {}

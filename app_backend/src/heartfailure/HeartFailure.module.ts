import { Module } from '@nestjs/common';
import { HeartFailureController } from './HeartFailure.controller';
import { HeartFailureService } from './HeartFailure.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HeartFailure } from './HeartFailure.entity';
import { UserModule } from 'src/user/patient/user.module';
import { User } from 'src/user/patient/user.entity';
@Module({
  imports: [UserModule,
    TypeOrmModule.forFeature([HeartFailure, User]),

  ],
  controllers: [HeartFailureController],
  providers: [HeartFailureService],
  exports: [HeartFailureService],
})
export class HeartFailureModule {}

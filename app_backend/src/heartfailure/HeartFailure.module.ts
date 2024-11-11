import { Module } from '@nestjs/common';
import { HeartFailureController } from './HeartFailure.controller';
import { HeartFailureService } from './HeartFailure.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HeartFailure } from './HeartFailure.entity';

import { forwardRef } from '@nestjs/common';
import { UserModule } from 'src/user/user.module';
@Module({
  imports: [UserModule,
    TypeOrmModule.forFeature([HeartFailure]),

  ],
  controllers: [HeartFailureController],
  providers: [HeartFailureService],
  exports: [HeartFailureService],
})
export class HeartFailureModule {}

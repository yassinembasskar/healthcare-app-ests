import { Module } from '@nestjs/common';
import { BrainStrokeController } from './BrainStroke.controller';
import { BrainStrokeService } from './BrainStroke.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BrainStroke } from './BrainStroke.entity';

import { forwardRef } from '@nestjs/common';
import { UserModule } from 'src/user/user.module';
@Module({
  imports: [UserModule,
    TypeOrmModule.forFeature([BrainStroke]),

  ],
  controllers: [BrainStrokeController],
  providers: [BrainStrokeService],
  exports: [BrainStrokeService],
})
export class BrainStrokeModule {}

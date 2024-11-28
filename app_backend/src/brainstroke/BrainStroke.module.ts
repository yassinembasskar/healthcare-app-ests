import { Module } from '@nestjs/common';
import { BrainStrokeController } from './BrainStroke.controller';
import { BrainStrokeService } from './BrainStroke.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BrainStroke } from './BrainStroke.entity';
import { UserModule } from 'src/user/patient/user.module';
import { User } from 'src/user/patient/user.entity';

@Module({
  imports: [UserModule,
    TypeOrmModule.forFeature([BrainStroke, User]),

  ],
  controllers: [BrainStrokeController],
  providers: [BrainStrokeService],
  exports: [BrainStrokeService],
})
export class BrainStrokeModule {}

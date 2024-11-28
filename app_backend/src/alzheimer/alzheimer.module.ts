import { Module } from '@nestjs/common';
import { AlzheimerController } from './alzheimer.controller';
import { AlzheimerService } from './alzheimer.service';

@Module({
  controllers: [AlzheimerController],
  providers: [AlzheimerService],
})
export class AlzheimerModule {}

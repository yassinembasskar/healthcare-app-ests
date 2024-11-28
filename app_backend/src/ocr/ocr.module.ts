import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from 'src/user/patient/user.entity';
import { LabTestEntity } from './labtest.entity';
import { ExtractionEntity } from './extraction.entity';
import { OcrService } from './ocr.service';
import { OcrController } from './ocr.controller';
import { BrainStroke } from 'src/brainstroke/BrainStroke.entity';
import { HeartFailure } from 'src/heartfailure/HeartFailure.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([User, LabTestEntity, ExtractionEntity, BrainStroke, HeartFailure]),
  ],
  controllers: [OcrController],
  providers: [OcrService]
})
export class OcrModule {}
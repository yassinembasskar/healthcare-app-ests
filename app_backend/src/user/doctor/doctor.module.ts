import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Doctor } from './doctor.entity';
import { DoctorService } from './doctor.service';
import { DoctorController } from './doctor.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Doctor])], // Register the Doctor entity with TypeORM
  controllers: [DoctorController],               // Add the DoctorController
  providers: [DoctorService],                    // Add the DoctorService
  exports: [DoctorService],
})
export class DoctorModule {}

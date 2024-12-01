import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { UserModule } from '../patient/user.module';
import { AdminModule } from '../admin/admin.module';
import { DoctorModule } from '../doctor/doctor.module';

@Module({
  imports: [UserModule,DoctorModule],
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}

import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { UserModule } from '../patient/user.module';
import { AdminModule } from '../admin/admin.module';

@Module({
  imports: [UserModule,AdminModule],
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}

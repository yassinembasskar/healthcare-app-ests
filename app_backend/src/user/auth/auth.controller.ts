import { Body, Controller, Post} from '@nestjs/common';
import { AuthService } from './auth.service';
import { User } from '../patient/user.entity';
import { admin } from '../admin/admin.entity';
import { InvalidCredantials } from 'src/exceptions/invalid-credantials.exception';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  async login(@Body() body: { email: string; password: string }): Promise<any> {
    const { email, password } = body;

    const entity = await this.authService.validateUserEmail(email, password);
    if (entity instanceof User) {
      return {'userId': entity.idPatient, 'role': 'patient', 'password': entity.password};
    } else if (entity instanceof admin) {
      return {'userId': entity.id, 'role': 'admin', 'password': entity.password};
    } else {
      throw new InvalidCredantials();
    }
  }

  @Post('logged')
  async logged(@Body() body: { userId: number; password: string, role: string }): Promise<any> {
    const {userId, password, role} = body;
    const entity = await this.authService.validateUserId(userId, password, role);
    if (entity ){
      return { success: true, message: 'Already Logged in' };
    } else {
      throw new InvalidCredantials();
    }
  }
}

import { HttpException, HttpStatus } from '@nestjs/common';

export class NotSecurePassword extends HttpException {
  constructor() {
    super('The new password is not secure', HttpStatus.BAD_REQUEST);
  }
}
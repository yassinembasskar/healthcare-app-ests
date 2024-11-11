import { HttpException, HttpStatus } from '@nestjs/common';

export class InvalidPassword extends HttpException {
  constructor() {
    super('The Password is Incorrect', HttpStatus.BAD_REQUEST);
  }
}
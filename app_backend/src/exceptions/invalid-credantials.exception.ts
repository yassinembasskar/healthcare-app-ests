import { HttpException, HttpStatus } from '@nestjs/common';

export class InvalidCredantials extends HttpException {
  constructor() {
    super('Invalid Credantials', HttpStatus.BAD_REQUEST);
  }
}
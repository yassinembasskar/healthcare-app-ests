import { HttpException, HttpStatus } from '@nestjs/common';

export class FullNameAlreadyExist extends HttpException {
  constructor() {
    super('Fullname Already Exist', HttpStatus.BAD_REQUEST);
  }
}
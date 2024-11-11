import { HttpException, HttpStatus } from '@nestjs/common';

export class EmailAlreadyExist extends HttpException {
  constructor() {
    super('Email Already Exist', HttpStatus.BAD_REQUEST);
  }
}
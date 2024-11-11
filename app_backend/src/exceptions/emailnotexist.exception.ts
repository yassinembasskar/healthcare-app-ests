import { HttpException, HttpStatus } from '@nestjs/common';

export class EmailDoesNotExist extends HttpException {
  constructor() {
    super('Email Does Not Exist', HttpStatus.BAD_REQUEST);
  }
}
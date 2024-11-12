import { Controller, Post, Body, Get, HttpException, HttpStatus } from '@nestjs/common';
import { BrainStrokeService } from './BrainStroke.service';
import { BrainStroke } from './BrainStroke.entity';
import { BrainStrokeDTO } from './BrainStroke.dto';
import { Logger } from '@nestjs/common';

@Controller('brainstroke')
export class BrainStrokeController {
  private readonly logger = new Logger(BrainStrokeController.name);
  constructor(private readonly brainStrokeService: BrainStrokeService) {}

  @Post('GetComponent')
  async getcomponentsbyuserid(@Body('id_patient') id_patient:number){
    try {
      this.logger.log(`Fetching components for patient ID: ${id_patient}`);
      return await this.brainStrokeService.getpredictioncomponenetsbyuserid(id_patient);
    } catch (error) {
      this.logger.error(`Failed to fetch components for patient ID: ${id_patient}`, error.stack);
      throw new HttpException('Unable to fetch components', HttpStatus.BAD_REQUEST);
    }
  }

  @Post('SaveComponents')
  async savecomponenets(@Body()brainStrokeDTO : BrainStrokeDTO){
    try {
      this.logger.log(`Saving components for patient ID: ${brainStrokeDTO.id_patient}`);
      return await this.brainStrokeService.saveComponents(brainStrokeDTO);
    } catch (error) {
      this.logger.error(`Failed to save components for patient ID: ${brainStrokeDTO.id_patient}`, error.stack);
      throw new HttpException('Unable to save components', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @Post('Prediction')
  async getpredictino(@Body('id_patient')id_patient : number){
    try {
      return await this.brainStrokeService.getpredictionbyuserid(id_patient);
    } catch (error) {
      throw new HttpException('Error fetching prediction', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }


}

import { Controller, Post, Body, Get, HttpException, HttpStatus, NotFoundException } from '@nestjs/common';
import { BrainStrokeService } from './BrainStroke.service';
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
      return await this.brainStrokeService.saveComponents(brainStrokeDTO);
    } catch (error) {
      throw new HttpException('Unable to save components', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @Post('Prediction')
  async getprediction(@Body('id_patient') id_patient : number){
    try {
      const prediction = await this.brainStrokeService.getpredictionbyuserid(id_patient);
      if (!prediction || Object.values(prediction).some(value => value === null || value === 'unknown')) {
        throw new NotFoundException('Prediction data is incomplete or missing for this user.');
      }
  
      return prediction;
    } catch (exception) {
      throw new NotFoundException('Error fetching prediction: ' + exception.message);
    }
  }
}
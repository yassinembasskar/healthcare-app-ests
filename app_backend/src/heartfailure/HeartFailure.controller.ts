import { Controller, Post, Body, NotFoundException, BadRequestException, HttpException, HttpStatus } from '@nestjs/common';
import { HeartFailureService } from './HeartFailure.service';
import { HeartFailureDTO } from './HeartFailure.dto';

@Controller('HeartFailure')
export class HeartFailureController {
  constructor(private readonly HeartFailureService: HeartFailureService) {}

  @Post('GetComponent')
  async getcomponentsbyuserid(@Body('id_patient')id_patient:number){
    return this.HeartFailureService.getpredictioncomponenetsbyuserid(id_patient);
  }

  @Post('SaveComponents')
  async savecomponenets(@Body()HeartFailureDTO : HeartFailureDTO){
      try {
          return this.HeartFailureService.saveComponents(HeartFailureDTO);
      } catch (error) {
        throw new HttpException('Unable to save components', HttpStatus.INTERNAL_SERVER_ERROR);
      }
  }

  @Post('prediction')
  async getprediction(@Body('id_patient') id_patient: number) {
    try {
        const prediction = await this.HeartFailureService.getpredictionbyuserid(id_patient);

        if (!prediction || Object.values(prediction).some(value => value === null || value === undefined)) {
            throw new BadRequestException('Prediction data is incomplete or missing for this user.');
        }
        return prediction;
    } catch (exception) {
        throw exception;
    }
}


}

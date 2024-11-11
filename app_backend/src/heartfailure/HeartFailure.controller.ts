import { Controller, Post, Body } from '@nestjs/common';
import { HeartFailureService } from './HeartFailure.service';
import { HeartFailure } from './HeartFailure.entity';
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

    return this.HeartFailureService.saveComponents(HeartFailureDTO);
  }

  @Post('prediction')
  async getprediction(@Body('id_patient')id_patient:number){
    return this.HeartFailureService.getpredictionbyuserid(id_patient);
  }
  @Post('py')
  async py(){
    this.HeartFailureService.runPythonScript('HeartFailure.py',['1111','122222']);
  }


}

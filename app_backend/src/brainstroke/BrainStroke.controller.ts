import { Controller, Post, Body, Get } from '@nestjs/common';
import { BrainStrokeService } from './BrainStroke.service';
import { BrainStroke } from './BrainStroke.entity';
import { BrainStrokeDTO } from './BrainStroke.dto';

@Controller('brainstroke')
export class BrainStrokeController {
  constructor(private readonly BrainStrokeService: BrainStrokeService) {}

  @Post('GetComponent')
  async getcomponentsbyuserid(@Body('id_patient')id_patient:number){
    console.log(id_patient);
    return this.BrainStrokeService.getpredictioncomponenetsbyuserid(id_patient);
  }

  @Post('SaveComponents')
  async savecomponenets(@Body()brainStrokeDTO : BrainStrokeDTO){
    console.log('controller')
    console.log(brainStrokeDTO);
    return this.BrainStrokeService.saveComponents(brainStrokeDTO);
  }

  @Get('py')
  async py(){
    return this.BrainStrokeService.processAndRunScript(['Male', "80.0"," 0", "1", 'Yes', 'Private', 'Rural', "105.92", "32.5", 'never smoked']);
  }

  @Post('Prediction')
  async getpredictino(@Body('id_patient')id_patient : number){
    return this.BrainStrokeService.getpredictionbyuserid(id_patient);
  }


}

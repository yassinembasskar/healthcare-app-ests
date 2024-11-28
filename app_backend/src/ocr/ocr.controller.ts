<<<<<<< HEAD
import { Controller, Post, Body, UploadedFile, UseInterceptors, Get } from '@nestjs/common';
=======
import { Controller, Post, Body, UploadedFile, UseInterceptors, Get, BadRequestException } from '@nestjs/common';
>>>>>>> origin/master
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';
import { OcrService } from './ocr.service'; 
import { LabTestEntity } from './labtest.entity';
import { ExtractionEntity } from './extraction.entity';
<<<<<<< HEAD
=======
import * as fs from 'fs';
>>>>>>> origin/master

@Controller('ocr')
export class OcrController {
  constructor(private readonly ocrService: OcrService) {}
<<<<<<< HEAD

  @Post('process')
  @UseInterceptors(
    FileInterceptor('image', {
      storage: diskStorage({
        destination: './src/ocr/img',
        filename: (req, file, callback) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
          const ext = extname(file.originalname);
          const filename = `${uniqueSuffix}${ext}`;
          callback(null, filename);
        },
      }),
    }),
  )
  async processImage(
    @UploadedFile() file: Express.Multer.File,
    @Body('id_patient') id: number,
  )
  : Promise<{ labtest: LabTestEntity; extractions: ExtractionEntity[] }>
   {
    const imagePath = `./src/ocr/img/${file.filename}`;

    const { extractions, labtest } = await this.ocrService.processImage(imagePath, id);

    const fs = require('fs');
    fs.unlink(imagePath, (err) => {
      if (err) {
        console.error('Failed to delete image:', err);
      } else {
        console.log('Image deleted successfully:', imagePath);
      }
    });

    return { labtest, extractions };
  }

=======
  @Post('process')
  @UseInterceptors(FileInterceptor('file'))
  async predict(@UploadedFile() file: Express.Multer.File,
    @Body('id_patient') id: number
  ): Promise<{ labtest: LabTestEntity; extractions: ExtractionEntity[] }> {
  
    if (!file) {    
      console.error('File is undefined');
      throw new Error('No file uploaded');
    }

    try {
      const imagePath = `./src/ocr/img/${file}`;
      console.log(imagePath);
      const { extractions, labtest } = await this.ocrService.processImage(imagePath, id);

      fs.unlink(imagePath, (err) => {
        if (err) {
          console.error('Failed to delete image:', err);
        } else {
          console.log('Image deleted successfully:', imagePath);
        }
      });  

      return { labtest, extractions };
    } catch (error) {
      console.error('Error processing image:', error);
      throw new Error('Image processing failed');
    }
  }


>>>>>>> origin/master
  @Post('save')
  async saveResults(
    @Body() body: { labtest: LabTestEntity; extractions: ExtractionEntity[] },
  ): Promise<void> {
    const { labtest, extractions } = body;
    console.log(labtest,extractions)
    await this.ocrService.saveTests(labtest, extractions);
  }

  @Post('get')
  async getlabtestbyuserid(@Body('id_patient') id_patient:number){
    return this.ocrService.getlabtestbyuserid(id_patient)
  }

  @Post('getextractions')
  async getextractionsbytestid(@Body('test_id')test_id : number){
    return this.ocrService.getextractionsbytestid(test_id);
  }


}


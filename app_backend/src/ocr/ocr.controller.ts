import { Controller, Post, Body, UploadedFile, UseInterceptors, Get, BadRequestException } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';
import { OcrService } from './ocr.service'; 
import { LabTestEntity } from './labtest.entity';
import { ExtractionEntity } from './extraction.entity';
import * as fs from 'fs';

@Controller('ocr')
export class OcrController {
  constructor(private readonly ocrService: OcrService) {}
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
  ): Promise<{ labtest: LabTestEntity; extractions: ExtractionEntity[] }> {
    try {
      if (!file) {
        throw new BadRequestException('No file uploaded');
      }
      console.log('hi tehre');
      const imagePath = `./src/ocr/img/${file.filename}`;
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


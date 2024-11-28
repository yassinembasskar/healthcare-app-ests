import { Controller, Post, Body, UploadedFile, UseInterceptors, Get } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';
import { AlzheimerService } from './alzheimer.service';
import * as fs from 'fs';
import * as path from 'path';
import axios from 'axios';
@Controller('alzheimer')
export class AlzheimerController {
  constructor(private readonly alzheimerService: AlzheimerService) {}

  @Post('predict')
  @UseInterceptors(FileInterceptor('file'))
  async predict(@UploadedFile() file: Express.Multer.File): Promise<string> {
    console.log('Request received');
  
    if (!file) {    
      console.error('File is undefined');
      throw new Error('No file uploaded');
    }
  
    console.log('Uploaded file:', file);
    return 'File uploaded successfully';
  }
  // @Get('test-model')
  // async testModel(): Promise<string> {
  //   const prediction = await this.alzheimerService.predict('C:\\Users\\tanan\\healthcare-app-ests\\app_backend\\src\\alzheimer\\moderateDem9.jpg');
  //     console.log('Prediction:', prediction);
  //     return prediction;
    // Step 1: Define the image path
    // const imagePath = "C://Users//tanan//Downloads//alzheimer's dataset//OriginalDatasetModerateDemented//moderateDem9.jpg"; // Replace with the local image path
    
    // // Step 2: Define where to save the image locally
    // const localFilePath = path.join(__dirname, '..', '..', 'uploads', 'test-image.jpg');

    // // Step 3: Check if the image exists at the given path
    // if (!fs.existsSync(imagePath)) {
    //   throw new Error('Image file does not exist at the provided path');
    // }

    // // Step 4: Copy the image from the original location to your local folder
    // try {
    //   fs.copyFileSync(imagePath, localFilePath);
    //   console.log('Image copied successfully.');
    // } catch (error) {
    //   console.error('Failed to copy the image:', error.message);
    //   throw new Error('Image copy failed');
    // }

    // // Step 5: Call the service to predict using the local file path
    // try {
    //   const prediction = await this.alzheimerService.predict(localFilePath);
    //   console.log('Prediction:', prediction);
    //   return prediction;
    // } catch (error) {
    //   console.error('Error during prediction:', error.message);
    //   throw error;
    // }
  // }
  @Post('test-model')
  async testModel(): Promise<string> {
    console.log('predicting')
    const imagePath = path.resolve('C:\\Users\\tanan\\healthcare-app-ests\\app_backend\\src\\alzheimer\\verymildDem990.jpg');
    const prediction = await this.alzheimerService.predict(imagePath);
    console.log('Prediction:', prediction); 
    return prediction;
  }



  
  @Post('Prediction')
  @UseInterceptors(
    FileInterceptor('image', {
      storage: diskStorage({
        destination: './src/alzheimer/img',
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
    
  )
  : Promise<string>
   {
    const imagePath = `./src/alzheimer/img/${file.filename}`;
    console.log(imagePath);

    // const { extractions, labtest } = await this.ocrService.processImage(imagePath, id);
    const prediction = await this.alzheimerService.predict(imagePath);
    console.log(prediction)
    const fs = require('fs');
    fs.unlink(imagePath, (err) => {
      if (err) {
        console.error('Failed to delete image:', err);
      } else {
        console.log('Image deleted successfully:', imagePath);
      }
    });

    return prediction;
  }
}

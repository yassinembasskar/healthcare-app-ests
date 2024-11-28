import { Injectable } from '@nestjs/common';
import { exec } from 'child_process';
import { promisify } from 'util';
import * as path from 'path';

const execPromise = promisify(exec);

@Injectable()
export class AlzheimerService {
  async predict(imagePath: string): Promise<string> {
    try {
      // Path to the Python script
      const pythonScriptPath = path.resolve(__dirname, 'C://Users//tanan//healthcare-app-ests//app_backend//src//alzheimer//alzheimer.py');

      // Command to execute the Python script with the image path as an argument
      const command = `python ${pythonScriptPath} ${imagePath}`;

      // Execute the Python script
      const { stdout } = await execPromise(command);

      // The prediction will be returned in stdout
      return stdout.trim();
    } catch (error) {
      throw new Error(`Error during prediction: ${error.message}`);
    }
  }
}

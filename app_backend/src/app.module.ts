import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UserModule } from './user/user.module';
import { AdminController } from './user/admin.controller';
import { AdminModule } from './user/admin.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthController } from './user/auth.controller';
import { authModule } from './user/auth.module';
import { BrainStrokeModule } from './brainstroke/BrainStroke.module';
import { HeartFailureModule } from './heartfailure/HeartFailure.module';
import { OcrModule } from './ocr/ocr.module';

@Module({
  imports: [UserModule,AdminModule,authModule,BrainStrokeModule,HeartFailureModule,OcrModule,
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'postgres',
      password: '2049',  
      database: 'PFE',
      entities: ["dist/**/*.entity{.ts,.js}"], 
      synchronize: true,
        
    }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}

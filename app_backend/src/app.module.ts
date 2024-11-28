import { forwardRef, Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UserModule } from './user/patient/user.module';
import { AdminModule } from './user/admin/admin.module';
import { AuthModule } from './user/auth/auth.module';
import { BrainStrokeModule } from './brainstroke/BrainStroke.module';
import { HeartFailureModule } from './heartfailure/HeartFailure.module';
import { OcrModule } from './ocr/ocr.module';
import { AlzheimerModule } from './alzheimer/alzheimer.module';
import { MulterModule } from '@nestjs/platform-express';
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        type: 'postgres',
        host: 'localhost',
        port: 5432,
        username: 'postgres',
        password: "123123123",
        database: 'healthview',
        entities: ["dist/**/*.entity{.ts,.js}"], 
        synchronize: true,
      }),
      inject: [ConfigService],
    }),
    forwardRef(() => UserModule),
    forwardRef(() => AdminModule),
    AuthModule,
    BrainStrokeModule,
    HeartFailureModule,
    OcrModule,AlzheimerModule,
    MulterModule.register({
      dest: './uploads', // Set the directory where files will be temporarily stored
    }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
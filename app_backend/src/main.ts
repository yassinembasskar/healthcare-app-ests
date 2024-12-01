import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as session from 'express-session';


async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.use(
    session({
      secret: 'your-secret-key', // Set a secret key for signing the session ID
      resave: false,
      saveUninitialized: false,
      cookie: { secure: false }, // Set to true if using https
    }),
  );
  app.enableCors();
  await app.listen(3000);
}
bootstrap();

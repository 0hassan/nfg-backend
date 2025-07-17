import fastifyHelmet from '@fastify/helmet';
import fastifyRateLimit from '@fastify/rate-limit';
import { Logger, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import {
  FastifyAdapter,
  NestFastifyApplication,
} from '@nestjs/platform-fastify';
import { AppModule } from './app.module';

async function bootstrap() {
  const logger = new Logger('Bootstrap');

  const app = await NestFactory.create<NestFastifyApplication>(
    AppModule,
    new FastifyAdapter({
      logger: true,
      trustProxy: true,
    }),
  );

  const configService = app.get(ConfigService);

  // Security middleware
  await app.register(fastifyHelmet, {
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        styleSrc: ["'self'", "'unsafe-inline'"],
        scriptSrc: ["'self'"],
        imgSrc: ["'self'", 'data:', 'https:'],
      },
    },
  });

  // Rate limiting
  await app.register(fastifyRateLimit, {
    max: configService.get<number>('app.rateLimit.max', 100),
    timeWindow: configService.get<number>('app.rateLimit.windowMs', 900000),
    errorResponseBuilder: () => {
      return {
        statusCode: 429,
        error: 'Too Many Requests',
        message: 'Rate limit exceeded, retry in a few minutes',
      };
    },
  });

  // Global prefix
  app.setGlobalPrefix(configService.get<string>('app.apiPrefix', 'api/v1'));

  // CORS
  app.enableCors({
    origin: configService.get<string[] | string>('app.cors.origin', '*'),
    credentials: configService.get<boolean>('app.cors.credentials', true),
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  });

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  const port = configService.get<number>('app.port', 3000);
  const host = configService.get<string>('app.host', '0.0.0.0');

  await app.listen(port, host);

  logger.log(`Application is running on: ${await app.getUrl()}`);
  logger.log(
    `Environment: ${configService.get<string>('app.nodeEnv', 'development')}`,
  );
}
bootstrap().catch((error) => {
  console.error('Error starting the application:', error);
  process.exit(1);
});

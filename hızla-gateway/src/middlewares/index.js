import express from 'express';
import { createCors, createXss, sqlInjectionMiddleware } from './security-middleware.js';
import helmetMiddleware from './helmet-middleware.js';
import compressionMiddleware from './compression-middleware.js';
import cookieParserMiddleware from './cookie-parser.js';
import checkUrl from './check-url-middleware.js';
import bodyParserJson from './body-parser-json-middleware.js';
import bodyParserUrlEncoded from './body-parser-url-encode-middleware.js';
import logMiddleware from './log-middleware.js';
import { authenticateJwt } from './middleware-list-middleware.js';
import rateLimit from 'express-rate-limit';

export default function middlewareFactory() {
  const router = express.Router();

  // 1. CORS
  router.use(createCors());
  // 2. Cookie parser
  router.use(cookieParserMiddleware);
  // 3. XSS temizle
  router.use(createXss());
  // 4. SQL injection engelle
  router.use(sqlInjectionMiddleware);
  // 5. Gzip
  router.use(compressionMiddleware);
  // 6. Helmet (güvenlik header'ları)
  router.use(helmetMiddleware);
  // 7. URL bazlı bypass placeholder
  router.use(checkUrl);
  // 8. Rate limit (login endpoint'i için sıkı)
  router.use(
    '/api/auth/login',
    rateLimit({ windowMs: 60 * 1000, max: 10, message: { status: 'error', message: 'Too many requests' } }),
  );
  // 9. Body parser (gateway kendi endpoint'leri + login için)
  router.use('/api/gateway', bodyParserJson);
  router.use('/api/gateway', bodyParserUrlEncoded);
  router.use('/api/auth/login', bodyParserJson);
  router.use('/api/auth/login', bodyParserUrlEncoded);
  // 10. JWT auth
  router.use(authenticateJwt);
  // 11. Log
  router.use(logMiddleware);

  return router;
}

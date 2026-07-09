import cors from 'cors';
import xss from 'xss-clean';
import appConfig from '../../packages/modules/config/index.js';

export function createCors() {
  const origins = appConfig.allowedOrigins.split(',').map((o) => o.trim());
  return cors({
    origin: (origin, cb) => {
      if (!origin || origins.includes(origin)) return cb(null, true);
      cb(new Error('CORS: origin not allowed'));
    },
    credentials: true,
  });
}

export function createXss() {
  return xss();
}

export function sqlInjectionMiddleware(req, res, next) {
  const SQL_PATTERN = /('|;|--|\b(SELECT|UPDATE|DELETE|INSERT|DROP|CREATE|ALTER|EXEC)\b)/gi;

  const check = (value) => {
    if (typeof value === 'string' && SQL_PATTERN.test(value)) return true;
    return false;
  };

  const sources = [req.body, req.query, req.params];
  for (const source of sources) {
    if (!source) continue;
    for (const val of Object.values(source)) {
      if (check(val)) {
        return res.status(403).json({ status: 'error', message: 'Forbidden' });
      }
    }
  }
  next();
}

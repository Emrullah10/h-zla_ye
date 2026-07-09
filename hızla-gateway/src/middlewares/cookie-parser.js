import cookieParser from 'cookie-parser';
import appConfig from '../../packages/modules/config/index.js';

export default function cookieParserMiddleware(req, res, next) {
  return cookieParser(appConfig.cookieSecret)(req, res, next);
}

import express from 'express';
import applyBodyParser from './body-parser-middleware.js';
import applyHelmet from './helmet-middleware.js';
import applyCompression from './compression-middleware.js';
import applyLog from './log-middleware.js';
import applyCors from './cors-middleware.js';
import restRoutes from '../routes/rest-routes.js';

export default (appConfig) => {
  const router = express.Router();

  applyHelmet(router);
  applyCors(router);
  applyLog(router);
  applyBodyParser(router);
  applyCompression(router);

  router.use(restRoutes(appConfig));

  return router;
};

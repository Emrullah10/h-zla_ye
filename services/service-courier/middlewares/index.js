import express from 'express';
import applyBodyParser from './body-parser-middleware.js';
import applyHelmet from './helmet-middleware.js';
import applyCompression from './compression-middleware.js';
import applyCors from './cors-middleware.js';
import applyLog from './log-middleware.js';
import restRoutes from '../routes/rest-routes.js';

export default (appConfig, serviceDiscoveryInstance, openApi, { broadcast } = {}) => {
  const router = express.Router();
  applyBodyParser(router);
  applyHelmet(router);
  applyCompression(router);
  applyCors(router);
  applyLog(router);
  router.use(restRoutes(appConfig, { broadcast }));
  return router;
};

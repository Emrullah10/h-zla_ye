import express from 'express';
import authController from '../src/interfaces/http/auth.controller.js';

export default (appConfig) => {
  const router = express.Router();
  const ctrl = authController(appConfig);

  router.post('/api/auth/login', ctrl.login);
  router.post('/api/auth/logout', ctrl.logout);
  router.post('/api/auth/refresh', ctrl.refresh);

  router.get('/app/health', (_req, res) => res.json({ status: 'ok', service: 'service-auth' }));

  return router;
};

import express from 'express';
import adminController from '../src/interfaces/http/admin.controller.js';
import { requireAuth } from '../src/shared/utils/auth-middleware.js';

export default (appConfig) => {
  const router = express.Router();
  const auth = requireAuth();
  const ctrl = adminController(appConfig);

  router.get('/api/admin/dashboard', auth, ctrl.getDashboard);
  router.get('/api/admin/drivers', auth, ctrl.getDrivers);
  router.post('/api/admin/drivers/:id/approve', auth, ctrl.approveDriver);
  router.post('/api/admin/drivers/:id/reject', auth, ctrl.rejectDriver);

  router.get('/app/health', (_req, res) => res.json({ status: 'ok', service: 'service-admin' }));

  return router;
};

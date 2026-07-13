import express from 'express';
import courierController from '../src/interfaces/http/courier.controller.js';
import { requireAuth } from '../src/shared/utils/auth-middleware.js';

export default (appConfig, { broadcast } = {}) => {
  const router = express.Router();
  const auth = requireAuth();
  const ctrl = courierController(appConfig, { broadcast });

  router.get('/api/courier/order/active', auth, ctrl.getActiveOrder);
  router.post('/api/courier/order', auth, ctrl.createOrder);
  router.post('/api/courier/order/:id/accept', auth, ctrl.acceptOrder);
  router.post('/api/courier/order/:id/reject', auth, ctrl.rejectOrder);
  router.post('/api/courier/order/:id/verify', auth, ctrl.verifyPackage);
  router.post('/api/courier/order/:id/rate', auth, ctrl.rateRestaurant);
  router.get('/api/courier/wallet', auth, ctrl.getWallet);
  router.get('/api/courier/earnings', auth, ctrl.getEarnings);
  router.get('/api/courier/quests', auth, ctrl.getQuests);
  router.post('/api/courier/support', auth, ctrl.createSupportTicket);
  router.post('/api/courier/location', auth, ctrl.updateLocation);
  router.get('/api/courier/location/latest', auth, ctrl.getLatestLocations);

  router.get('/app/health', (_req, res) => res.json({ status: 'ok', service: 'service-courier' }));

  return router;
};

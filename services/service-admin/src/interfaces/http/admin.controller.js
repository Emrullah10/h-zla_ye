import { buildContainer } from '../../container.js';

export default function adminController(_appConfig) {
  const { getDashboard, getDrivers, approveDriver, rejectDriver } = buildContainer();

  return {
    async getDashboard(_req, res, next) {
      try {
        const result = await getDashboard();
        res.json(result);
      } catch (err) { next(err); }
    },

    async getDrivers(_req, res, next) {
      try {
        const result = await getDrivers();
        res.json(result);
      } catch (err) { next(err); }
    },

    async approveDriver(req, res, next) {
      try {
        const result = await approveDriver({ appId: req.params.id, adminId: req.user.userId });
        res.json(result);
      } catch (err) { next(err); }
    },

    async rejectDriver(req, res, next) {
      try {
        const result = await rejectDriver({ appId: req.params.id, adminId: req.user.userId, reason: req.body.reason });
        res.json(result);
      } catch (err) { next(err); }
    },
  };
}

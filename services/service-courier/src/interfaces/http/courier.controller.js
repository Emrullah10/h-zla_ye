import { buildContainer } from '../../container.js';

export default function courierController(_appConfig) {
  const {
    getActiveOrder,
    acceptOrder,
    rejectOrder,
    verifyPackage,
    rateRestaurant,
    getWallet,
    getEarnings,
    getQuests,
    createSupportTicket,
  } = buildContainer();

  return {
    async getActiveOrder(req, res, next) {
      try {
        const result = await getActiveOrder({ userId: req.user.userId });
        res.json(result);
      } catch (err) { next(err); }
    },

    async acceptOrder(req, res, next) {
      try {
        const result = await acceptOrder({ userId: req.user.userId, orderId: req.params.id });
        res.json(result);
      } catch (err) { next(err); }
    },

    async rejectOrder(req, res, next) {
      try {
        const result = await rejectOrder({ userId: req.user.userId, orderId: req.params.id });
        res.json(result);
      } catch (err) { next(err); }
    },

    async verifyPackage(req, res, next) {
      try {
        const result = await verifyPackage({ userId: req.user.userId, orderId: req.params.id, qrCode: req.body.qrCode });
        res.json(result);
      } catch (err) { next(err); }
    },

    async rateRestaurant(req, res, next) {
      try {
        const result = await rateRestaurant({ userId: req.user.userId, orderId: req.params.id, ...req.body });
        res.json(result);
      } catch (err) { next(err); }
    },

    async getWallet(req, res, next) {
      try {
        const result = await getWallet({ userId: req.user.userId });
        res.json(result);
      } catch (err) { next(err); }
    },

    async getEarnings(req, res, next) {
      try {
        const result = await getEarnings({ userId: req.user.userId, period: req.query.period });
        res.json(result);
      } catch (err) { next(err); }
    },

    async getQuests(req, res, next) {
      try {
        const result = await getQuests({ userId: req.user.userId });
        res.json(result);
      } catch (err) { next(err); }
    },

    async createSupportTicket(req, res, next) {
      try {
        const result = await createSupportTicket({ userId: req.user.userId, ...req.body });
        res.json(result);
      } catch (err) { next(err); }
    },
  };
}

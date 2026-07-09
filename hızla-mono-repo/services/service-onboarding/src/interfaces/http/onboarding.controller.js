import { buildContainer } from '../../container.js';

export default function onboardingController(_appConfig) {
  const { getStatus, selectVehicle, uploadDocument, completeTraining } = buildContainer();

  return {
    async getStatus(req, res, next) {
      try {
        const result = await getStatus({ userId: req.user.userId });
        res.json(result);
      } catch (err) { next(err); }
    },

    async selectVehicle(req, res, next) {
      try {
        const result = await selectVehicle({ userId: req.user.userId, vehicleType: req.body.vehicleType });
        res.json(result);
      } catch (err) { next(err); }
    },

    async uploadDocument(req, res, next) {
      try {
        const filePath = req.file?.path ?? req.body.filePath;
        const result = await uploadDocument({ userId: req.user.userId, docType: req.body.docType, filePath });
        res.json(result);
      } catch (err) { next(err); }
    },

    async completeTraining(req, res, next) {
      try {
        const result = await completeTraining({ userId: req.user.userId });
        res.json(result);
      } catch (err) { next(err); }
    },
  };
}

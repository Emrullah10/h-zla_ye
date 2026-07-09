export default function createGetStatusUseCase({ applicationRepository, documentRepository, trainingRepository }) {
  return async function getStatus({ userId }) {
    const app = await applicationRepository.findByUserId(userId);
    if (!app) return { status: 'pending', appId: null, vehicleType: null, documents: [], trainingComplete: false };

    const [documents, training] = await Promise.all([
      documentRepository.findByAppId(app.appId),
      trainingRepository.findByAppId(app.appId),
    ]);

    return {
      status: app.status,
      appId: app.appId,
      vehicleType: app.vehicleType,
      documents,
      trainingComplete: !!training,
    };
  };
}

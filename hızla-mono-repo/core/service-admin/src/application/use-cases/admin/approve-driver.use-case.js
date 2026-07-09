import { AdminErrors } from '../../../domain/admin/admin.errors.js';

export default function createApproveDriverUseCase({ driverRepository, adminActionRepository }) {
  return async function approveDriver({ appId, adminId }) {
    const app = await driverRepository.findApplicationById(appId);
    if (!app) throw AdminErrors.APPLICATION_NOT_FOUND();

    const result = await driverRepository.approveApplication(appId, adminId);
    await adminActionRepository.log({
      adminId,
      actionType: 'approve_driver',
      targetId: app.userId,
    });
    return result;
  };
}

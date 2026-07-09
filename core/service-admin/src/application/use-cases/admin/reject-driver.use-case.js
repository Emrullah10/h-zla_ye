import { AdminErrors } from '../../../domain/admin/admin.errors.js';

export default function createRejectDriverUseCase({ driverRepository, adminActionRepository }) {
  return async function rejectDriver({ appId, adminId, notes }) {
    const app = await driverRepository.findApplicationById(appId);
    if (!app) throw AdminErrors.APPLICATION_NOT_FOUND();

    const result = await driverRepository.rejectApplication(appId, adminId, notes);
    await adminActionRepository.log({
      adminId,
      actionType: 'reject_driver',
      targetId: app.userId,
      notes,
    });
    return result;
  };
}

import { CourierErrors } from '../../../domain/courier/courier.errors.js';

export default function createCreateSupportTicketUseCase({ courierRepository, supportRepository }) {
  return async function createSupportTicket({ userId, category, subject, message }) {
    if (!category) throw CourierErrors.MISSING_CATEGORY();
    if (!message) throw CourierErrors.MISSING_MESSAGE();

    const courier = await courierRepository.findByUserId(userId);
    if (!courier) throw CourierErrors.NOT_FOUND();

    return supportRepository.create({
      courierId: courier.courierId,
      category,
      subject: subject ?? '',
      message,
    });
  };
}

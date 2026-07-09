import { CourierErrors } from '../../../domain/courier/courier.errors.js';

export default function createRejectOrderUseCase({ courierRepository, orderRepository }) {
  return async function rejectOrder({ userId, orderId }) {
    const courier = await courierRepository.findByUserId(userId);
    if (!courier) throw CourierErrors.NOT_FOUND();

    const order = await orderRepository.findById(orderId);
    if (!order) throw CourierErrors.ORDER_NOT_FOUND();
    if (order.status !== 'accepted') throw CourierErrors.ORDER_NOT_ACCEPTED();

    return orderRepository.updateStatus(orderId, 'rejected');
  };
}

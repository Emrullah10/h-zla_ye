import { CourierErrors } from '../../../domain/courier/courier.errors.js';

export default function createAcceptOrderUseCase({ courierRepository, orderRepository }) {
  return async function acceptOrder({ userId, orderId }) {
    const courier = await courierRepository.findByUserId(userId);
    if (!courier) throw CourierErrors.NOT_FOUND();

    const order = await orderRepository.findById(orderId);
    if (!order) throw CourierErrors.ORDER_NOT_FOUND();
    if (order.status !== 'pending') throw CourierErrors.ORDER_NOT_PENDING();

    return orderRepository.updateStatus(orderId, 'accepted');
  };
}

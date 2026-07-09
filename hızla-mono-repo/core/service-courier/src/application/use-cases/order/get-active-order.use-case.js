import { CourierErrors } from '../../../domain/courier/courier.errors.js';

export default function createGetActiveOrderUseCase({ courierRepository, orderRepository }) {
  return async function getActiveOrder({ userId }) {
    const courier = await courierRepository.findByUserId(userId);
    if (!courier) throw CourierErrors.NOT_FOUND();

    return orderRepository.findActiveByCourierId(courier.courierId);
  };
}

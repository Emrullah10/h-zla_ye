import { CourierErrors } from '../../../domain/courier/courier.errors.js';

export default function createVerifyPackageUseCase({ courierRepository, orderRepository }) {
  return async function verifyPackage({ userId, orderId, qrCode }) {
    const courier = await courierRepository.findByUserId(userId);
    if (!courier) throw CourierErrors.NOT_FOUND();

    const order = await orderRepository.findById(orderId);
    if (!order) throw CourierErrors.ORDER_NOT_FOUND();
    if (order.qrCode !== qrCode) throw CourierErrors.INVALID_QR_CODE();

    return orderRepository.updateStatus(orderId, 'picked_up');
  };
}

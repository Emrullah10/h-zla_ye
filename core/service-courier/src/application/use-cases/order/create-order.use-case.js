import { CourierErrors } from '../../../domain/courier/courier.errors.js';

function toCoord(value) {
  if (value === undefined || value === null || value === '') return null;
  const n = Number(value);
  return Number.isFinite(n) ? n : NaN;
}

export default function createCreateOrderUseCase({ courierRepository, orderRepository }) {
  return async function createOrder({
    courierId, restaurantName, platform, pickupAddr, deliveryAddr,
    pickupLat, pickupLng, deliveryLat, deliveryLng, amount, fee, distanceMeters,
  }) {
    if (!restaurantName || !pickupAddr || !deliveryAddr) throw CourierErrors.MISSING_ORDER_FIELDS();

    const coords = [pickupLat, pickupLng, deliveryLat, deliveryLng].map(toCoord);
    if (coords.some((c) => Number.isNaN(c))) throw CourierErrors.INVALID_COORDINATES();
    const [pLat, pLng, dLat, dLng] = coords;

    let assignedCourierId = courierId;
    if (!assignedCourierId) {
      const courier = await courierRepository.findFirstAvailable();
      if (!courier) throw CourierErrors.NO_AVAILABLE_COURIER();
      assignedCourierId = courier.courierId;
    }

    return orderRepository.create({
      courierId: assignedCourierId,
      restaurantName,
      platform: platform || 'unknown',
      pickupAddr,
      deliveryAddr,
      pickupLat: pLat,
      pickupLng: pLng,
      deliveryLat: dLat,
      deliveryLng: dLng,
      amount: amount ?? 0,
      fee: fee ?? 0,
      distanceMeters: distanceMeters ?? 0,
    });
  };
}

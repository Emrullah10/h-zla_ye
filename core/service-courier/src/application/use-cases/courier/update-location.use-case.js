import { CourierErrors } from '../../../domain/courier/courier.errors.js';

export default function createUpdateLocationUseCase({ courierRepository, broadcast }) {
  return async function updateLocation({ userId, lat, lng }) {
    const courier = await courierRepository.findByUserId(userId);
    if (!courier) throw CourierErrors.NOT_FOUND();

    const latNum = Number(lat);
    const lngNum = Number(lng);
    if (!Number.isFinite(latNum) || !Number.isFinite(lngNum)) throw CourierErrors.INVALID_COORDINATES();

    const updated = await courierRepository.updateLocation(courier.courierId, latNum, lngNum);

    if (typeof broadcast === 'function') {
      broadcast({
        type: 'courier:location',
        courierId: updated.courierId,
        lat: updated.lastLat,
        lng: updated.lastLng,
        at: updated.locationUpdatedAt,
      });
    }

    return updated;
  };
}

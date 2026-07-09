import { CourierErrors } from '../../../domain/courier/courier.errors.js';

const VALID_PERIODS = ['weekly', 'monthly'];

export default function createGetEarningsUseCase({ courierRepository, earningsRepository }) {
  return async function getEarnings({ userId, period }) {
    if (!VALID_PERIODS.includes(period)) throw CourierErrors.INVALID_PERIOD();

    const courier = await courierRepository.findByUserId(userId);
    if (!courier) throw CourierErrors.NOT_FOUND();

    return earningsRepository.getEarnings(courier.courierId, period);
  };
}

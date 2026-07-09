import { CourierErrors } from '../../../domain/courier/courier.errors.js';

export default function createGetQuestsUseCase({ courierRepository, questRepository }) {
  return async function getQuests({ userId }) {
    const courier = await courierRepository.findByUserId(userId);
    if (!courier) throw CourierErrors.NOT_FOUND();

    const quests = await questRepository.findByCourierId(courier.courierId);
    return { quests };
  };
}

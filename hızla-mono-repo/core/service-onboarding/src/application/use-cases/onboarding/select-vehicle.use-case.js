import { OnboardingErrors } from '../../../domain/onboarding/onboarding.errors.js';

const VALID_VEHICLES = ['bicycle', 'motorcycle', 'car'];

export default function createSelectVehicleUseCase({ applicationRepository }) {
  return async function selectVehicle({ userId, vehicleType }) {
    if (!VALID_VEHICLES.includes(vehicleType)) throw OnboardingErrors.INVALID_VEHICLE_TYPE();

    let app = await applicationRepository.findByUserId(userId);
    if (!app) {
      app = await applicationRepository.create({ userId, status: 'pending', vehicleType: null });
    }

    return applicationRepository.updateVehicle(app.appId, vehicleType);
  };
}

import { OnboardingErrors } from '../../../domain/onboarding/onboarding.errors.js';

export default function createCompleteTrainingUseCase({ applicationRepository, trainingRepository }) {
  return async function completeTraining({ userId }) {
    const app = await applicationRepository.findByUserId(userId);
    if (!app) throw OnboardingErrors.APPLICATION_NOT_FOUND();

    const existing = await trainingRepository.findByAppId(app.appId);
    if (existing) throw OnboardingErrors.TRAINING_ALREADY_COMPLETE();

    await trainingRepository.create(app.appId);
    return applicationRepository.updateStatus(app.appId, 'training_complete');
  };
}

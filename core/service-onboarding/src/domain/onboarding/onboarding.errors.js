import { DomainError } from '../errors/domain-error.js';

export const OnboardingErrors = {
  APPLICATION_NOT_FOUND: () => new DomainError('Application not found', 404),
  INVALID_VEHICLE_TYPE: () => new DomainError('Invalid vehicle type', 400),
  INVALID_DOCUMENT_TYPE: () => new DomainError('Invalid document type', 400),
  TRAINING_ALREADY_COMPLETE: () => new DomainError('Training already completed', 400),
};

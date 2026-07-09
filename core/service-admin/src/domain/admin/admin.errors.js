import { DomainError } from '../errors/domain-error.js';

export const AdminErrors = {
  APPLICATION_NOT_FOUND: () => new DomainError('Application not found', 404),
};

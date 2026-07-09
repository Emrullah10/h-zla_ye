import { DomainError } from '../errors/domain-error.js';

export const UserErrors = {
  INVALID_CREDENTIALS: () => new DomainError('Invalid credentials', 401),
  MISSING_PHONE: () => new DomainError('Phone number is required', 400),
  MISSING_PASSWORD: () => new DomainError('Password is required', 400),
  USER_NOT_FOUND: () => new DomainError('User not found', 404),
  INVALID_REFRESH_TOKEN: () => new DomainError('Invalid refresh token', 401),
  ACCOUNT_LOCKED: () => new DomainError('Too many failed attempts. Try again in 15 minutes.', 429),
};

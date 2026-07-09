import { DomainError } from '../errors/domain-error.js';

export const CourierErrors = {
  NOT_FOUND: () => new DomainError('Courier not found', 404),
  ORDER_NOT_FOUND: () => new DomainError('Order not found', 404),
  ORDER_NOT_PENDING: () => new DomainError('Order is not in pending state', 400),
  ORDER_NOT_ACCEPTED: () => new DomainError('Order is not in accepted state', 400),
  ORDER_NOT_DELIVERED: () => new DomainError('Order is not in delivered state', 400),
  INVALID_QR_CODE: () => new DomainError('QR code does not match', 400),
  INVALID_RATING: () => new DomainError('Rating must be between 1 and 5', 400),
  INVALID_PERIOD: () => new DomainError('Period must be weekly or monthly', 400),
  MISSING_CATEGORY: () => new DomainError('Support category is required', 400),
  MISSING_MESSAGE: () => new DomainError('Support message is required', 400),
};

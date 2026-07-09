export class DomainError extends Error {
  constructor(message, statusCode = 400) {
    super(message);
    this.name = 'DomainError';
    this.statusCode = statusCode;
  }
}

export class ApplicationError extends Error {
  constructor(message, statusCode = 400) {
    super(message);
    this.name = 'ApplicationError';
    this.statusCode = statusCode;
  }
}

export class InfrastructureError extends Error {
  constructor(message, statusCode = 500) {
    super(message);
    this.name = 'InfrastructureError';
    this.statusCode = statusCode;
  }
}

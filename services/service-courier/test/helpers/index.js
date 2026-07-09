export const fakeAppConfig = {
  jwtSecret: 'test-secret',
  jwtExpiresIn: 900,
};

export function makeFakeCourierRepo(overrides = {}) {
  return {
    async findByUserId(_userId) { return null; },
    async findById(_courierId) { return null; },
    ...overrides,
  };
}

export function makeFakeOrderRepo(overrides = {}) {
  return {
    async findActiveByCourierId(_courierId) { return null; },
    async findById(_orderId) { return null; },
    async updateStatus(_orderId, _status) { return null; },
    ...overrides,
  };
}

export function makeFakeWalletRepo(overrides = {}) {
  return {
    async findByCourierId(_courierId) { return null; },
    async findTransactions(_courierId) { return []; },
    ...overrides,
  };
}

export function makeFakeQuestRepo(overrides = {}) {
  return {
    async findByCourierId(_courierId) { return []; },
    ...overrides,
  };
}

export function makeFakeSupportRepo(overrides = {}) {
  return {
    async create(_ticket) { return { ticketId: 'ticket-001' }; },
    ...overrides,
  };
}

export function makeFakeEarningsRepo(overrides = {}) {
  return {
    async getEarnings(_courierId, _period) { return null; },
    ...overrides,
  };
}

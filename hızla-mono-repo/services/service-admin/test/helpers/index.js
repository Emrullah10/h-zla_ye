export function makeFakeDashboardRepo(overrides = {}) {
  return {
    async getStats() { return { activeCouriers: 0, todayOrders: 0, dailyRevenue: 0, pendingApprovals: 0 }; },
    ...overrides,
  };
}

export function makeFakeDriverRepo(overrides = {}) {
  return {
    async findPending() { return []; },
    async findByUserId(_userId) { return null; },
    async findApplicationById(_appId) { return null; },
    async approveApplication(_appId, _adminId) { return null; },
    async rejectApplication(_appId, _adminId, _notes) { return null; },
    ...overrides,
  };
}

export function makeFakeAdminActionRepo(overrides = {}) {
  return {
    async log(_data) { return null; },
    ...overrides,
  };
}

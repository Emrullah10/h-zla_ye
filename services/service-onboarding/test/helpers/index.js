export function makeFakeApplicationRepo(overrides = {}) {
  return {
    async findByUserId(_userId) { return null; },
    async create(_data) { return null; },
    async updateStatus(_appId, _status) { return null; },
    async updateVehicle(_appId, _vehicleType) { return null; },
    ...overrides,
  };
}

export function makeFakeDocumentRepo(overrides = {}) {
  return {
    async create(_data) { return null; },
    async findByAppId(_appId) { return []; },
    ...overrides,
  };
}

export function makeFakeTrainingRepo(overrides = {}) {
  return {
    async create(_appId) { return null; },
    async findByAppId(_appId) { return null; },
    ...overrides,
  };
}

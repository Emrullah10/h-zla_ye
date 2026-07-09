// Fake in-memory userRepository for unit tests
export function makeFakeUserRepo(users = []) {
  return {
    async findByPhone(phone) {
      return users.find((u) => u.phone === phone) ?? null;
    },
    async findById(userId) {
      return users.find((u) => u.userId === userId) ?? null;
    },
  };
}

// Fake in-memory Redis client
export function makeFakeRedis(store = {}) {
  return {
    async set(key, value, _opts) {
      store[key] = value;
    },
    async get(key) {
      return store[key] ?? null;
    },
    async del(key) {
      delete store[key];
    },
    async incr(key) {
      const current = parseInt(store[key] ?? '0', 10);
      store[key] = String(current + 1);
      return current + 1;
    },
    async expire(_key, _ttl) {},
  };
}

export const fakeAppConfig = {
  jwtSecret: 'test-secret',
  jwtExpiresIn: 900,
  jwtRefreshExpiresIn: 604800,
};

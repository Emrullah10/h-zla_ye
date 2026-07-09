import { describe, it, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { getTestDb, cleanTestUsers, closeTestDb } from '../helpers/test-db.js';
import { getTestRedis, closeTestRedis } from '../helpers/test-redis.js';
import { UserRepositoryImpl } from '#core/infrastructure/persistence/repositories/user.repository-impl.js';
import { hashPassword } from '#core/shared/utils/crypto.js';
import createLoginUseCase from '#core/application/use-cases/auth/login.use-case.js';
import createLogoutUseCase from '#core/application/use-cases/auth/logout.use-case.js';
import createRefreshUseCase from '#core/application/use-cases/auth/refresh.use-case.js';

const TEST_PHONE = '+905559998877';
const TEST_PASSWORD = 'integrationPass!';

const appConfig = {
  jwtSecret: 'int-test-secret',
  jwtExpiresIn: 900,
  jwtRefreshExpiresIn: 3600,
};

describe('auth integration', () => {
  let db;
  let redis;
  let userRepo;

  before(async () => {
    db = getTestDb();
    redis = getTestRedis();
    userRepo = new UserRepositoryImpl(db);

    // Temizle ve test kullanıcısı ekle
    await cleanTestUsers([TEST_PHONE]);
    const hash = await hashPassword(TEST_PASSWORD);
    await db.query(
      `INSERT INTO auth.users (user_phone, user_password_hash, user_role)
       VALUES ($1, $2, 'courier')`,
      [TEST_PHONE, hash],
    );
  });

  after(async () => {
    await cleanTestUsers([TEST_PHONE]);
    await closeTestDb();
    await closeTestRedis();
  });

  it('gerçek DB ile login başarıyla tamamlanır', async () => {
    const login = createLoginUseCase({ userRepository: userRepo, redisClient: redis, appConfig });
    const result = await login({ phone: TEST_PHONE, password: TEST_PASSWORD });

    assert.ok(result.token);
    assert.ok(result.refreshToken);
    assert.equal(result.expiresIn, 900);
  });

  it('gerçek Redis\'e refreshToken yazılır', async () => {
    const login = createLoginUseCase({ userRepository: userRepo, redisClient: redis, appConfig });
    const result = await login({ phone: TEST_PHONE, password: TEST_PASSWORD });

    const user = await userRepo.findByPhone(TEST_PHONE);
    const stored = JSON.parse(await redis.get(`rt:${user.userId}`));

    assert.equal(stored.token, result.refreshToken);
    assert.equal(stored.userId, user.userId);
  });

  it('login → refresh → yeni token üretilir', async () => {
    const login = createLoginUseCase({ userRepository: userRepo, redisClient: redis, appConfig });
    const loginResult = await login({ phone: TEST_PHONE, password: TEST_PASSWORD });

    const user = await userRepo.findByPhone(TEST_PHONE);
    const refresh = createRefreshUseCase({ redisClient: redis, userRepository: userRepo, appConfig });
    const refreshResult = await refresh({
      refreshToken: loginResult.refreshToken,
      userId: user.userId,
    });

    assert.ok(refreshResult.token);
    assert.notEqual(refreshResult.refreshToken, loginResult.refreshToken);
  });

  it('login → logout → refresh artık çalışmaz', async () => {
    const login = createLoginUseCase({ userRepository: userRepo, redisClient: redis, appConfig });
    const loginResult = await login({ phone: TEST_PHONE, password: TEST_PASSWORD });
    const user = await userRepo.findByPhone(TEST_PHONE);

    const logout = createLogoutUseCase({ redisClient: redis, appConfig });
    await logout({ token: loginResult.token });

    const refresh = createRefreshUseCase({ redisClient: redis, userRepository: userRepo, appConfig });
    await assert.rejects(
      () => refresh({ refreshToken: loginResult.refreshToken, userId: user.userId }),
      (err) => {
        assert.equal(err.statusCode, 401);
        return true;
      },
    );
  });

  it('yanlış şifreyle login reddedilir', async () => {
    const login = createLoginUseCase({ userRepository: userRepo, redisClient: redis, appConfig });
    await assert.rejects(
      () => login({ phone: TEST_PHONE, password: 'wrongPass' }),
      (err) => {
        assert.equal(err.statusCode, 401);
        return true;
      },
    );
  });
});

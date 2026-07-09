import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { hashPassword } from '#core/shared/utils/crypto.js';
import { makeFakeUserRepo, makeFakeRedis, fakeAppConfig } from '../../helpers/index.js';
import createLoginUseCase from '#core/application/use-cases/auth/login.use-case.js';

async function makeUser(overrides = {}) {
  return {
    userId: 'user-001',
    phone: '+905550000001',
    passwordHash: await hashPassword('correctPass'),
    role: 'courier',
    ...overrides,
  };
}

describe('login use-case', () => {
  it('telefon numarası eksikse MISSING_PHONE hatası fırlatır', async () => {
    const login = createLoginUseCase({
      userRepository: makeFakeUserRepo(),
      redisClient: makeFakeRedis(),
      appConfig: fakeAppConfig,
    });

    await assert.rejects(
      () => login({ phone: '', password: 'pass' }),
      (err) => {
        assert.equal(err.statusCode, 400);
        assert.match(err.message, /phone/i);
        return true;
      },
    );
  });

  it('şifre eksikse MISSING_PASSWORD hatası fırlatır', async () => {
    const login = createLoginUseCase({
      userRepository: makeFakeUserRepo(),
      redisClient: makeFakeRedis(),
      appConfig: fakeAppConfig,
    });

    await assert.rejects(
      () => login({ phone: '+905550000001', password: '' }),
      (err) => {
        assert.equal(err.statusCode, 400);
        assert.match(err.message, /password/i);
        return true;
      },
    );
  });

  it('telefon bulunamazsa INVALID_CREDENTIALS hatası fırlatır', async () => {
    const login = createLoginUseCase({
      userRepository: makeFakeUserRepo([]),
      redisClient: makeFakeRedis(),
      appConfig: fakeAppConfig,
    });

    await assert.rejects(
      () => login({ phone: '+905550000099', password: 'anyPass' }),
      (err) => {
        assert.equal(err.statusCode, 401);
        return true;
      },
    );
  });

  it('şifre yanlışsa INVALID_CREDENTIALS hatası fırlatır', async () => {
    const user = await makeUser();
    const login = createLoginUseCase({
      userRepository: makeFakeUserRepo([user]),
      redisClient: makeFakeRedis(),
      appConfig: fakeAppConfig,
    });

    await assert.rejects(
      () => login({ phone: user.phone, password: 'wrongPass' }),
      (err) => {
        assert.equal(err.statusCode, 401);
        return true;
      },
    );
  });

  it('başarılı loginde token, refreshToken ve expiresIn döner', async () => {
    const user = await makeUser();
    const redisStore = {};
    const login = createLoginUseCase({
      userRepository: makeFakeUserRepo([user]),
      redisClient: makeFakeRedis(redisStore),
      appConfig: fakeAppConfig,
    });

    const result = await login({ phone: user.phone, password: 'correctPass' });

    assert.ok(result.token, 'token olmalı');
    assert.ok(result.refreshToken, 'refreshToken olmalı');
    assert.equal(result.expiresIn, fakeAppConfig.jwtExpiresIn);
  });

  it('başarılı loginde refreshToken Redis\'e yazılır', async () => {
    const user = await makeUser();
    const redisStore = {};
    const login = createLoginUseCase({
      userRepository: makeFakeUserRepo([user]),
      redisClient: makeFakeRedis(redisStore),
      appConfig: fakeAppConfig,
    });

    const result = await login({ phone: user.phone, password: 'correctPass' });

    const stored = JSON.parse(redisStore[`rt:${user.userId}`]);
    assert.equal(stored.token, result.refreshToken);
    assert.equal(stored.userId, user.userId);
  });
});

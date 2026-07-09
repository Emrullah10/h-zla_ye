import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeUserRepo, makeFakeRedis, fakeAppConfig } from '../../helpers/index.js';
import createRefreshUseCase from '#core/application/use-cases/auth/refresh.use-case.js';

const testUser = {
  userId: 'user-001',
  phone: '+905550000001',
  passwordHash: 'hash',
  role: 'courier',
};

describe('refresh use-case', () => {
  it('refreshToken eksikse INVALID_REFRESH_TOKEN hatası fırlatır', async () => {
    const refresh = createRefreshUseCase({
      redisClient: makeFakeRedis(),
      userRepository: makeFakeUserRepo([testUser]),
      appConfig: fakeAppConfig,
    });

    await assert.rejects(
      () => refresh({ refreshToken: '', userId: testUser.userId }),
      (err) => {
        assert.equal(err.statusCode, 401);
        return true;
      },
    );
  });

  it('userId eksikse INVALID_REFRESH_TOKEN hatası fırlatır', async () => {
    const refresh = createRefreshUseCase({
      redisClient: makeFakeRedis(),
      userRepository: makeFakeUserRepo([testUser]),
      appConfig: fakeAppConfig,
    });

    await assert.rejects(
      () => refresh({ refreshToken: 'some-token', userId: '' }),
      (err) => {
        assert.equal(err.statusCode, 401);
        return true;
      },
    );
  });

  it('Redis\'te token yoksa INVALID_REFRESH_TOKEN hatası fırlatır', async () => {
    const refresh = createRefreshUseCase({
      redisClient: makeFakeRedis({}),
      userRepository: makeFakeUserRepo([testUser]),
      appConfig: fakeAppConfig,
    });

    await assert.rejects(
      () => refresh({ refreshToken: 'rt-abc', userId: testUser.userId }),
      (err) => {
        assert.equal(err.statusCode, 401);
        return true;
      },
    );
  });

  it('Redis\'teki token eşleşmezse INVALID_REFRESH_TOKEN hatası fırlatır', async () => {
    const store = {
      [`rt:${testUser.userId}`]: JSON.stringify({ token: 'rt-different', userId: testUser.userId }),
    };
    const refresh = createRefreshUseCase({
      redisClient: makeFakeRedis(store),
      userRepository: makeFakeUserRepo([testUser]),
      appConfig: fakeAppConfig,
    });

    await assert.rejects(
      () => refresh({ refreshToken: 'rt-abc', userId: testUser.userId }),
      (err) => {
        assert.equal(err.statusCode, 401);
        return true;
      },
    );
  });

  it('başarılı refresh\'te yeni token ve yeni refreshToken döner', async () => {
    const oldRefreshToken = 'rt-old';
    const store = {
      [`rt:${testUser.userId}`]: JSON.stringify({ token: oldRefreshToken, userId: testUser.userId }),
    };
    const refresh = createRefreshUseCase({
      redisClient: makeFakeRedis(store),
      userRepository: makeFakeUserRepo([testUser]),
      appConfig: fakeAppConfig,
    });

    const result = await refresh({ refreshToken: oldRefreshToken, userId: testUser.userId });

    assert.ok(result.token, 'yeni JWT token olmalı');
    assert.ok(result.refreshToken, 'yeni refreshToken olmalı');
    assert.notEqual(result.refreshToken, oldRefreshToken, 'refreshToken rotate edilmeli');
    assert.equal(result.expiresIn, fakeAppConfig.jwtExpiresIn);
  });

  it('başarılı refresh\'te Redis\'e yeni refreshToken yazılır', async () => {
    const oldRefreshToken = 'rt-old';
    const store = {
      [`rt:${testUser.userId}`]: JSON.stringify({ token: oldRefreshToken, userId: testUser.userId }),
    };
    const refresh = createRefreshUseCase({
      redisClient: makeFakeRedis(store),
      userRepository: makeFakeUserRepo([testUser]),
      appConfig: fakeAppConfig,
    });

    const result = await refresh({ refreshToken: oldRefreshToken, userId: testUser.userId });

    const newStored = JSON.parse(store[`rt:${testUser.userId}`]);
    assert.equal(newStored.token, result.refreshToken);
    assert.equal(newStored.userId, testUser.userId);
  });
});

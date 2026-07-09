import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { signJwt } from '#core/shared/utils/crypto.js';
import { makeFakeRedis, fakeAppConfig } from '../../helpers/index.js';
import createLogoutUseCase from '#core/application/use-cases/auth/logout.use-case.js';

describe('logout use-case', () => {
  it('token yoksa hata fırlatmaz', async () => {
    const logout = createLogoutUseCase({
      redisClient: makeFakeRedis(),
      appConfig: fakeAppConfig,
    });
    await assert.doesNotReject(() => logout({ token: null }));
  });

  it('geçersiz token olsa bile hata fırlatmaz', async () => {
    const logout = createLogoutUseCase({
      redisClient: makeFakeRedis(),
      appConfig: fakeAppConfig,
    });
    await assert.doesNotReject(() => logout({ token: 'garbage.token.here' }));
  });

  it('geçerli token ile Redis\'ten refresh token silinir', async () => {
    const userId = 'user-001';
    const store = { [`rt:${userId}`]: JSON.stringify({ token: 'rt-abc', userId }) };
    const token = signJwt({ userId, role: 'courier' }, fakeAppConfig.jwtSecret, 900);

    const logout = createLogoutUseCase({
      redisClient: makeFakeRedis(store),
      appConfig: fakeAppConfig,
    });

    await logout({ token });

    assert.equal(store[`rt:${userId}`], undefined);
  });
});

import { signJwt } from '../../../shared/utils/crypto.js';
import { UserErrors } from '../../../domain/user/user.errors.js';
import { randomUUID } from 'crypto';

export default function createRefreshUseCase({ redisClient, userRepository, appConfig }) {
  return async function refresh({ refreshToken, userId }) {
    if (!refreshToken || !userId) throw UserErrors.INVALID_REFRESH_TOKEN();

    const stored = await redisClient.get(`rt:${userId}`);
    if (!stored) throw UserErrors.INVALID_REFRESH_TOKEN();

    const parsed = JSON.parse(stored);
    if (parsed.token !== refreshToken) throw UserErrors.INVALID_REFRESH_TOKEN();

    const user = await userRepository.findById(userId);
    if (!user) throw UserErrors.INVALID_REFRESH_TOKEN();

    const payload = { userId: user.userId, role: user.role };
    const token = signJwt(payload, appConfig.jwtSecret, appConfig.jwtExpiresIn);
    const newRefreshToken = randomUUID();

    const ttl = appConfig.jwtRefreshExpiresIn;
    await redisClient.set(
      `rt:${user.userId}`,
      JSON.stringify({ token: newRefreshToken, userId: user.userId }),
      'EX',
      ttl,
    );

    return { token, expiresIn: appConfig.jwtExpiresIn, refreshToken: newRefreshToken };
  };
}

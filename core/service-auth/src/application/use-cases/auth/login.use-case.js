import { validateLoginInput } from '../../../shared/utils/validation.js';
import { comparePassword } from '../../../shared/utils/crypto.js';
import { UserErrors } from '../../../domain/user/user.errors.js';

const MAX_ATTEMPTS = 5;
const LOCK_TTL = 60 * 15; // 15 minutes

export default function createLoginUseCase({ userRepository, redisClient }) {
  return async function login({ phone, password }) {
    validateLoginInput({ phone, password });

    const lockKey = `login:lock:${phone}`;
    const attemptsKey = `login:attempts:${phone}`;

    const locked = await redisClient.get(lockKey);
    if (locked) throw UserErrors.ACCOUNT_LOCKED();

    const user = await userRepository.findByPhone(phone);
    const isValid = user ? await comparePassword(password, user.passwordHash) : false;

    if (!user || !isValid) {
      const attempts = await redisClient.incr(attemptsKey);
      if (attempts === 1) await redisClient.expire(attemptsKey, LOCK_TTL);
      if (attempts >= MAX_ATTEMPTS) {
        await redisClient.set(lockKey, '1', 'EX', LOCK_TTL);
        await redisClient.del(attemptsKey);
      }
      throw UserErrors.INVALID_CREDENTIALS();
    }

    await redisClient.del(attemptsKey);

    // Token üretimi gateway'de (onProxyRes hook). Sadece user bilgisi döndür.
    return {
      userId: user.userId,
      role: user.role,
      userPermissionList: user.role === 'admin' ? ['admin:*'] : ['courier:*'],
      driver: { id: user.userId, phone: user.phone },
      onboardingStatus: user.role === 'admin' ? 'APPROVED' : 'pending',
    };
  };
}

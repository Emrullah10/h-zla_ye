import { verifyJwt } from '../../../shared/utils/crypto.js';

export default function createLogoutUseCase({ redisClient, appConfig }) {
  return async function logout({ token }) {
    if (!token) return;
    try {
      const decoded = verifyJwt(token, appConfig.jwtSecret);
      await redisClient.del(`rt:${decoded.userId}`);
    } catch {
      // Token geçersiz olsa bile logout başarılı sayılır
    }
  };
}

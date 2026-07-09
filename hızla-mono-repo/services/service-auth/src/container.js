import datasources from '@hizla/datasource/index.js';
import { UserRepositoryImpl } from '#core/infrastructure/persistence/repositories/user.repository-impl.js';
import createLoginUseCase from '#core/application/use-cases/auth/login.use-case.js';
import createLogoutUseCase from '#core/application/use-cases/auth/logout.use-case.js';
import createRefreshUseCase from '#core/application/use-cases/auth/refresh.use-case.js';

export const buildContainer = (appConfig) => {
  const userRepository = new UserRepositoryImpl(datasources.coreAppDb);
  const redisClient = datasources.coreAppRedis.client;

  return {
    login: createLoginUseCase({ userRepository, redisClient }),
    logout: createLogoutUseCase({ redisClient, appConfig }),
    refresh: createRefreshUseCase({ redisClient, userRepository, appConfig }),
  };
};

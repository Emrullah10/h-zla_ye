const rawAppConfig = {
  name: { env: 'SERVICE_AUTH_NAME', type: 'string', default: 'service-auth' },
  url: { env: 'SERVICE_AUTH_REST_URL', type: 'string', default: 'http://127.0.0.1:3001' },
  port: { env: 'SERVICE_AUTH_PORT', type: 'integer', default: 3001 },
  basePath: { env: 'SERVICE_AUTH_BASE_PATH', type: 'string', default: '/api/auth' },
  basePathPrefix: { env: 'SERVICE_AUTH_BASE_PATH_PREFIX', type: 'string', default: '' },
  version: { env: 'SERVICE_AUTH_VERSION', type: 'string', default: '1.0.0' },
  description: { env: 'SERVICE_AUTH_DESCRIPTION', type: 'string', default: 'Hızla Ye Auth Service' },
  nodeEnv: { env: 'NODE_ENV', type: 'string', default: 'development' },
  jwtSecret: { env: 'JWT_SECRET', type: 'string', default: 'change_me_to_a_random_256bit_secret' },
  jwtExpiresIn: { env: 'JWT_EXPIRES_IN', type: 'integer', default: 900 },
  jwtRefreshExpiresIn: { env: 'JWT_REFRESH_EXPIRES_IN', type: 'integer', default: 604800 },
};

export default rawAppConfig;

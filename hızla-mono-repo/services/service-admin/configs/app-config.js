const rawAppConfig = {
  name: { env: 'SERVICE_ADMIN_NAME', type: 'string', default: 'service-admin' },
  url: { env: 'SERVICE_ADMIN_REST_URL', type: 'string', default: 'http://127.0.0.1:3004' },
  port: { env: 'SERVICE_ADMIN_PORT', type: 'integer', default: 3004 },
  basePath: { env: 'SERVICE_ADMIN_BASE_PATH', type: 'string', default: '/api/admin' },
  basePathPrefix: { env: 'SERVICE_ADMIN_BASE_PATH_PREFIX', type: 'string', default: '' },
  version: { env: 'SERVICE_ADMIN_VERSION', type: 'string', default: '1.0.0' },
  description: { env: 'SERVICE_ADMIN_DESCRIPTION', type: 'string', default: 'Hızla Ye Admin Service' },
  nodeEnv: { env: 'NODE_ENV', type: 'string', default: 'development' },
  jwtSecret: { env: 'JWT_SECRET', type: 'string', default: 'change_me_to_a_random_256bit_secret' },
};

export default rawAppConfig;

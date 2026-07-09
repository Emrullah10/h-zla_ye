const rawAppConfig = {
  name: { env: 'SERVICE_COURIER_NAME', type: 'string', default: 'service-courier' },
  url: { env: 'SERVICE_COURIER_REST_URL', type: 'string', default: 'http://127.0.0.1:3002' },
  port: { env: 'SERVICE_COURIER_PORT', type: 'integer', default: 3002 },
  basePath: { env: 'SERVICE_COURIER_BASE_PATH', type: 'string', default: '/api/courier' },
  basePathPrefix: { env: 'SERVICE_COURIER_BASE_PATH_PREFIX', type: 'string', default: '' },
  version: { env: 'SERVICE_COURIER_VERSION', type: 'string', default: '1.0.0' },
  description: { env: 'SERVICE_COURIER_DESCRIPTION', type: 'string', default: 'Hızla Ye Courier Service' },
  nodeEnv: { env: 'NODE_ENV', type: 'string', default: 'development' },
  jwtSecret: { env: 'JWT_SECRET', type: 'string', default: 'change_me_to_a_random_256bit_secret' },
};

export default rawAppConfig;

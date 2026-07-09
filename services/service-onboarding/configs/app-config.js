const rawAppConfig = {
  name: { env: 'SERVICE_ONBOARDING_NAME', type: 'string', default: 'service-onboarding' },
  url: { env: 'SERVICE_ONBOARDING_REST_URL', type: 'string', default: 'http://127.0.0.1:3003' },
  port: { env: 'SERVICE_ONBOARDING_PORT', type: 'integer', default: 3003 },
  basePath: { env: 'SERVICE_ONBOARDING_BASE_PATH', type: 'string', default: '/api/onboarding' },
  basePathPrefix: { env: 'SERVICE_ONBOARDING_BASE_PATH_PREFIX', type: 'string', default: '' },
  version: { env: 'SERVICE_ONBOARDING_VERSION', type: 'string', default: '1.0.0' },
  description: { env: 'SERVICE_ONBOARDING_DESCRIPTION', type: 'string', default: 'Hızla Ye Onboarding Service' },
  nodeEnv: { env: 'NODE_ENV', type: 'string', default: 'development' },
  jwtSecret: { env: 'JWT_SECRET', type: 'string', default: 'change_me_to_a_random_256bit_secret' },
  uploadDir: { env: 'UPLOAD_DIR', type: 'string', default: './uploads' },
  uploadMaxFileSizeMb: { env: 'UPLOAD_MAX_FILE_SIZE_MB', type: 'integer', default: 10 },
};

export default rawAppConfig;

const rawAppConfig = {
  name: { env: 'GATEWAY_NAME', type: 'string', default: 'hizla-gateway' },
  url: { env: 'GATEWAY_URL', type: 'string', default: 'http://127.0.0.1:4000' },
  port: { env: 'GATEWAY_PORT', type: 'integer', default: 4000 },
  basePath: { env: 'GATEWAY_BASE_PATH', type: 'string', default: '/api' },
  basePathPrefix: { env: 'GATEWAY_BASE_PATH_PREFIX', type: 'string', default: '' },
  nodeEnv: { env: 'NODE_ENV', type: 'string', default: 'development' },
  cookieSecret: { env: 'COOKIE_SECRET', type: 'string', default: 'change_me_to_256bit_random_secret' },
  allowedOrigins: { env: 'ALLOWED_ORIGINS', type: 'string', default: 'http://localhost:5173' },

  jwtPrivateKeyPath: { env: 'JWT_PRIVATE_KEY_PATH', type: 'string', default: './private.pem' },
  jwtPublicKeyPath: { env: 'JWT_PUBLIC_KEY_PATH', type: 'string', default: './public.pem' },
  jwtAccessExpiresMinutes: { env: 'JWT_ACCESS_EXPIRES_MINUTES', type: 'integer', default: 2880 },
  jwtRefreshExpiresMinutes: { env: 'JWT_REFRESH_EXPIRES_MINUTES', type: 'integer', default: 1440 },

  serviceAuthUrl: { env: 'SERVICE_AUTH_REST_URL', type: 'string', default: 'http://127.0.0.1:3001' },
  serviceCourierUrl: { env: 'SERVICE_COURIER_REST_URL', type: 'string', default: 'http://127.0.0.1:3002' },
  serviceOnboardingUrl: { env: 'SERVICE_ONBOARDING_REST_URL', type: 'string', default: 'http://127.0.0.1:3003' },
  serviceAdminUrl: { env: 'SERVICE_ADMIN_REST_URL', type: 'string', default: 'http://127.0.0.1:3004' },
};

export default rawAppConfig;

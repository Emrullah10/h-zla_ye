const rawDatasourceConfig = [
  {
    name: { env: 'SERVICE_ONBOARDING_DB_NAME', type: 'string', default: 'coreAppDb' },
    type: { env: 'SERVICE_ONBOARDING_DB_TYPE', type: 'string', default: 'postgre' },
    connectionString: {
      env: 'CORE_APP_DB_CONNECTION_STRING',
      type: 'string',
      default: 'postgres://emrullah@localhost:5432/hizla_dev',
    },
    options: {
      env: 'SERVICE_ONBOARDING_DB_OPTIONS',
      type: 'string',
      default: '-c search_path=onboarding,auth,shared',
    },
  },
  {
    name: { env: 'SERVICE_ONBOARDING_REDIS_NAME', type: 'string', default: 'coreAppRedis' },
    type: { env: 'SERVICE_ONBOARDING_REDIS_TYPE', type: 'string', default: 'redis' },
    url: { env: 'CORE_REDIS_URL', type: 'string', default: 'redis://127.0.0.1:6379' },
    password: { env: 'CORE_REDIS_PASSWORD', type: 'string', default: '' },
    db: { env: 'CORE_REDIS_DB', type: 'integer', default: 0 },
  },
  {
    name: { env: 'SERVICE_ONBOARDING_DISCOVERY_REDIS_NAME', type: 'string', default: 'serviceDiscoveryRedis' },
    type: { env: 'SERVICE_ONBOARDING_DISCOVERY_REDIS_TYPE', type: 'string', default: 'redis' },
    url: { env: 'CORE_DISCOVERY_REDIS_URL', type: 'string', default: 'redis://127.0.0.1:6379' },
    password: { env: 'CORE_DISCOVERY_REDIS_PASSWORD', type: 'string', default: '' },
    db: { env: 'SERVICE_ONBOARDING_DISCOVERY_REDIS_DB', type: 'integer', default: 1 },
  },
];

export default rawDatasourceConfig;

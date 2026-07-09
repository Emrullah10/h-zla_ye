const rawDatasourceConfig = [
  {
    name: { env: 'GATEWAY_REDIS_NAME', type: 'string', default: 'coreAppRedis' },
    type: { env: 'GATEWAY_REDIS_TYPE', type: 'string', default: 'redis' },
    url: { env: 'CORE_REDIS_URL', type: 'string', default: 'redis://127.0.0.1:6379' },
    password: { env: 'CORE_REDIS_PASSWORD', type: 'string', default: '' },
    db: { env: 'CORE_REDIS_DB', type: 'integer', default: 0 },
  },
  {
    name: { env: 'GATEWAY_DISCOVERY_REDIS_NAME', type: 'string', default: 'serviceDiscoveryRedis' },
    type: { env: 'GATEWAY_DISCOVERY_REDIS_TYPE', type: 'string', default: 'redis' },
    url: { env: 'CORE_DISCOVERY_REDIS_URL', type: 'string', default: 'redis://127.0.0.1:6379' },
    password: { env: 'CORE_DISCOVERY_REDIS_PASSWORD', type: 'string', default: '' },
    db: { env: 'GATEWAY_DISCOVERY_REDIS_DB', type: 'integer', default: 1 },
  },
];

export default rawDatasourceConfig;

import datasources from '../../packages/modules/datasource/index.js';

const SERVICE_KEY_PREFIX = 'hizla:service:';
const RESTART_CHANNEL = 'hizla.fct.servicerestarted';
const HEARTBEAT_TTL = 10; // seconds

export async function registerService({ name, url, basePath }) {
  const redis = datasources.serviceDiscoveryRedis.client;
  await redis.hmset(`${SERVICE_KEY_PREFIX}${name}`, { name, url, basePath });
  // Heartbeat: servis canlı olduğunu işaretle
  await redis.set(`hizla:health:${name}`, Date.now(), 'EX', HEARTBEAT_TTL);
}

export async function discoverAllServices() {
  const redis = datasources.serviceDiscoveryRedis.client;
  const keys = await redis.keys(`${SERVICE_KEY_PREFIX}*`);
  if (!keys.length) return [];
  const services = await Promise.all(
    keys.map((key) => redis.hgetall(key)),
  );
  return services.filter(Boolean);
}

export async function publishServiceRestart(name) {
  const redis = datasources.coreAppRedis.client;
  await redis.publish(RESTART_CHANNEL, JSON.stringify({ name }));
}

export async function subscribeServiceRestart(callback) {
  // Pub/Sub için ayrı bir Redis bağlantısı gerekiyor (subscribe modu)
  const Redis = (await import('ioredis')).default;
  const redisUrl = process.env.CORE_DISCOVERY_REDIS_URL || 'redis://127.0.0.1:6379';
  const subClient = new Redis(redisUrl);

  subClient.subscribe(RESTART_CHANNEL, (err) => {
    if (err) console.error('Gateway service-restart subscribe error:', err);
    else console.log(`Gateway subscribed to ${RESTART_CHANNEL}`);
  });

  subClient.on('message', (channel, message) => {
    if (channel === RESTART_CHANNEL) {
      try {
        const data = JSON.parse(message);
        callback(data);
      } catch { /* ignore malformed messages */ }
    }
  });

  return subClient;
}

export async function startHeartbeat(name, url, basePath) {
  const redis = datasources.serviceDiscoveryRedis.client;
  setInterval(async () => {
    try {
      await redis.hmset(`${SERVICE_KEY_PREFIX}${name}`, { name, url, basePath });
      await redis.set(`hizla:health:${name}`, Date.now(), 'EX', HEARTBEAT_TTL);
    } catch { /* swallow — redis reconnect handles it */ }
  }, 3000);
}

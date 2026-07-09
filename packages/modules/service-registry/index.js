// Servisler startup'ta bu modül aracılığıyla gateway Redis'e kaydolur ve restart sinyali yayınlar

const SERVICE_KEY_PREFIX = 'hizla:service:';
const RESTART_CHANNEL = 'hizla.fct.servicerestarted';
const HEARTBEAT_INTERVAL_MS = 3000;
const HEARTBEAT_TTL = 10; // seconds

export async function registerWithGateway({ name, url, basePath, redisClient }) {
  await redisClient.hmset(`${SERVICE_KEY_PREFIX}${name}`, { name, url, basePath });
  await redisClient.set(`hizla:health:${name}`, Date.now(), 'EX', HEARTBEAT_TTL);

  // Pub/sub bildirim: gateway route'larını yenilesin
  await redisClient.publish(RESTART_CHANNEL, JSON.stringify({ name, url, basePath }));

  console.log(`[service-registry] ${name} gateway'e kaydedildi (${basePath} → ${url})`);

  // Heartbeat: gateway'e "hâlâ canlıyım" sinyali
  setInterval(async () => {
    try {
      await redisClient.set(`hizla:health:${name}`, Date.now(), 'EX', HEARTBEAT_TTL);
    } catch { /* redis reconnect bekle */ }
  }, HEARTBEAT_INTERVAL_MS);
}

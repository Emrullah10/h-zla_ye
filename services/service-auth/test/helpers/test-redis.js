import Redis from 'ioredis';

let client = null;

export function getTestRedis() {
  if (!client) {
    client = new Redis({ host: '127.0.0.1', port: 6379, db: 9 });
  }
  return {
    async set(key, value, opts) {
      if (opts?.EX) {
        await client.set(key, value, 'EX', opts.EX);
      } else {
        await client.set(key, value);
      }
    },
    async get(key) {
      return client.get(key);
    },
    async del(key) {
      return client.del(key);
    },
  };
}

export async function closeTestRedis() {
  if (client) {
    await client.quit();
    client = null;
  }
}

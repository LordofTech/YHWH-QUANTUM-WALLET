
import Redis from 'ioredis';

let client: Redis | null = null;

export function getRedis(): Redis | null {
  if (!process.env.REDIS_URL) return null;
  if (!client) {
    client = new Redis(process.env.REDIS_URL, {
      maxRetriesPerRequest: 2,
      lazyConnect: true
    });
    client.on('error', (e) => console.error('[redis] error', e.message));
  }
  return client;
}

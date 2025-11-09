
import { Request, Response, NextFunction } from 'express';
import { getRedis } from '../services/redis.service';

/**
 * Idempotency middleware backed by Redis when available, else in-memory.
 */
const mem = new Map<string, { status: number; body: any; ts: number }>();
const TTL = 10 * 60; // seconds

export async function idempotency(req: Request, res: Response, next: NextFunction) {
  const key = req.header('Idempotency-Key');
  if (!key) return next();
  const r = getRedis();

  if (r) {
    try {
      const cached = await r.get(`idem:${key}`);
      if (cached) {
        const parsed = JSON.parse(cached);
        return res.status(parsed.status).json(parsed.body);
      }
      const json = res.json.bind(res);
      (res as any).json = async (body: any) => {
        const status = res.statusCode || 200;
        await r.setex(`idem:${key}`, TTL, JSON.stringify({ status, body }));
        return json(body);
      };
      return next();
    } catch (_e) {
      // fallback to memory
    }
  }

  const now = Date.now();
  const entry = mem.get(key);
  if (entry && now - entry.ts < TTL * 1000) {
    return res.status(entry.status).json(entry.body);
  }
  const json = res.json.bind(res);
  (res as any).json = (body: any) => {
    const status = res.statusCode || 200;
    mem.set(key, { status, body, ts: now });
    return json(body);
  };
  next();
}

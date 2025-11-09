
import { Request, Response, NextFunction } from 'express';
import { verifyIdToken } from '../services/firebase.service';
import { getRedis } from '../services/redis.service';

export const authenticate = async (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'No token provided' });
  }
  const token = authHeader.split(' ')[1];
  const r = getRedis();
  try {
    if (r) {
      const cached = await r.get(`token:${token}`);
      if (cached) {
        (req as any).user = JSON.parse(cached);
        return next();
      }
    }
    const user = await verifyIdToken(token);
    (req as any).user = user;
    if (r) await r.setex(`token:${token}`, 300, JSON.stringify(user));
    next();
  } catch (_error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
};


import { Request, Response, NextFunction } from 'express';
import { prisma } from '../database/prisma';
import { getRedis } from '../services/redis.service';

export type Role = 'user' | 'agent' | 'admin';

export async function loadRole(req: Request, _res: Response, next: NextFunction) {
  const uid = (req as any).user?.uid;
  if (!uid) return next();
  try {
    if (process.env.ADMIN_UID && uid === process.env.ADMIN_UID) {
      (req as any).role = 'admin';
      return next();
    }
    const r = getRedis();
    if (r) {
      const cached = await r.get(`role:${uid}`);
      if (cached) { (req as any).role = cached as Role; return next(); }
    }
    const user = await prisma.user.findUnique({ where: { uid } });
    const role = (user?.role || 'user') as Role;
    (req as any).role = role;
    if (r) await r.setex(`role:${uid}`, 300, role);
    next();
  } catch (e) {
    next(e);
  }
}

export function authorize(...allowed: Role[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    const role = (req as any).role as Role || 'user';
    if (!allowed.includes(role)) {
      return res.status(403).json({ error: 'Forbidden: insufficient role' });
    }
    next();
  };
}

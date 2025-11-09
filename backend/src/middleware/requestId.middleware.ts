
import { Request, Response, NextFunction } from 'express';
import { randomUUID } from 'crypto';

export function requestId(req: Request, _res: Response, next: NextFunction) {
  (req as any).id = req.headers['x-request-id'] || randomUUID();
  next();
}

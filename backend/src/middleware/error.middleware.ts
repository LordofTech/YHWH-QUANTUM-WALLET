
import { Request, Response, NextFunction } from 'express';

export function notFound(_req: Request, res: Response) {
  res.status(404).json({ error: 'Route not found' });
}

export function errorHandler(err: any, req: Request, res: Response, _next: NextFunction) {
  const status = err.status || 500;
  const message = err.message || 'Internal Server Error';
  const rid = (req as any).id;
  if (process.env.NODE_ENV !== 'production') {
    console.error('[ERR]', rid, err);
  }
  res.status(status).json({ error: message, requestId: rid });
}

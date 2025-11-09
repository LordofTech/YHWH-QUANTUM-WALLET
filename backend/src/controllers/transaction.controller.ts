
import { Request, Response } from 'express';
import { TransactionService } from '../services/transaction.service';

export const createOnlineTx = async (req: Request, res: Response) => {
  const { walletId, amount, type, lat, lng, metadata } = req.body;
  if (!walletId || amount === undefined || !type) {
    return res.status(400).json({ error: 'Missing required fields' });
  }
  try {
    const row = await TransactionService.createOnline(walletId, Number(amount), type, lat, lng, metadata);
    res.json(row);
  } catch (e: any) { res.status(500).json({ error: e.message }); }
};

export const getNearbyTx = async (req: Request, res: Response) => {
  const { lat, lng, radius = 50000 } = req.query as any;
  if (!lat || !lng) return res.status(400).json({ error: 'lat and lng are required' });
  try {
    const rows = await TransactionService.nearby(Number(lng), Number(lat), Number(radius));
    res.json(rows);
  } catch (e: any) { res.status(500).json({ error: e.message }); }
};

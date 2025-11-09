
import { Request, Response } from 'express';
import { TransactionService } from '../services/transaction.service';

export const listTransactions = async (req: Request, res: Response) => {
  const { walletId, limit = '20', offset = '0', type, status } = req.query as any;
  try {
    const where: any = {};
    if (walletId) where.wallet_id = walletId;
    if (type) where.type = type;
    if (status) where.status = status;
    const rows = await TransactionService.list(where, Number(limit), Number(offset));
    res.json(rows);
  } catch (e: any) { res.status(500).json({ error: e.message }); }
};

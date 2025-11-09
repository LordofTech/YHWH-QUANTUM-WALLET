
import { Request, Response } from 'express';
import { WalletService } from '../services/wallet.service';

export const createWallet = async (req: Request, res: Response) => {
  const { user_id, type, name } = req.body;
  if (!user_id || !type) return res.status(400).json({ error: 'user_id and type are required' });
  try {
    const wallet = await WalletService.create(user_id, type, name);
    res.json(wallet);
  } catch (e: any) { res.status(500).json({ error: e.message }); }
};

export const listWallets = async (req: Request, res: Response) => {
  const userId = (req.query.user_id as string) || (req as any).user?.uid;
  if (!userId) return res.status(400).json({ error: 'user_id query param required' });
  try {
    const wallets = await WalletService.listForUser(userId);
    res.json(wallets);
  } catch (e: any) { res.status(500).json({ error: e.message }); }
};

export const transfer = async (req: Request, res: Response) => {
  const { fromWalletId, toWalletId, amount } = req.body;
  if (!fromWalletId || !toWalletId || !amount) return res.status(400).json({ error: 'Missing fields' });
  try {
    await WalletService.transfer(fromWalletId, toWalletId, Number(amount));
    res.json({ ok: true });
  } catch (e: any) { res.status(500).json({ error: e.message }); }
};

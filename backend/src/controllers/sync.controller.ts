import { Request, Response } from 'express';
import { pool } from '../database/connection';

export const reconcileSync = async (req: Request, res: Response) => {
  const { walletId, transactions } = req.body;

  try {
    const results: any[] = [];
    for (const tx of (transactions || [])) {
      const result = await pool.query(
        `INSERT INTO transactions (wallet_id, amount, type, metadata)
         VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING RETURNING *`,
        [walletId, tx.amount, tx.type, tx]
      );
      if (result.rows[0]) results.push(result.rows[0]);
    }
    res.json({ reconciled: results.length });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

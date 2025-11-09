
import { Router } from 'express';
import { pool } from '../database/connection';
import { authenticate } from '../middleware/auth.middleware';
import { createWallet, listWallets, transfer } from '../controllers/wallet.controller';

const router = Router();

router.get('/:id', authenticate, async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('SELECT * FROM wallets WHERE id = $1', [id]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Wallet not found' });
    res.json(result.rows[0]);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/', authenticate, listWallets);
router.post('/', authenticate, createWallet);
router.post('/transfer', authenticate, transfer);

export default router;


import { Router } from 'express';
import { createOnlineTx, getNearbyTx } from '../controllers/transaction.controller';
import { listTransactions } from '../controllers/transaction.list.controller';
import { authenticate } from '../middleware/auth.middleware';

const router = Router();

router.post('/online', authenticate, createOnlineTx);
router.get('/geo/nearby', authenticate, getNearbyTx);
router.get('/', authenticate, listTransactions);

export default router;

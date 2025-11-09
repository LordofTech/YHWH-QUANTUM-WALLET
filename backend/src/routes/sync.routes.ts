import { Router } from 'express';
import { reconcileSync } from '../controllers/sync.controller';
import { authenticate } from '../middleware/auth.middleware';

const router = Router();

router.post('/reconcile', authenticate, reconcileSync);

export default router;

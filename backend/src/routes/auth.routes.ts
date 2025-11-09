import { Router } from 'express';
const router = Router();

router.get('/verify', (req, res) => {
  res.json({ message: 'Use Firebase client SDK for phone auth' });
});

export default router;

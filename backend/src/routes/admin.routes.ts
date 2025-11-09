import { Router } from 'express';
import { authenticate } from '../middleware/auth.middleware';
import { loadRole, authorize } from '../middleware/rbac.middleware';
import { prisma } from '../database/database'; // ✅ fixed

const router = Router();

// All admin routes require: authenticated + role loaded + admin role
router.use(authenticate, loadRole, authorize('admin'));

router.post('/users/role', async (req, res) => {
  const { uid, role } = req.body;

  if (!uid || !role) {
    return res.status(400).json({ error: 'uid and role required' });
  }

  if (!['user', 'agent', 'admin'].includes(role)) {
    return res.status(400).json({ error: 'invalid role' });
  }

  try {
    const upsert = await prisma.user.upsert({
      where: { uid },
      update: { role },
      create: { uid, role },
    });

    res.json({ uid: upsert.uid, role: upsert.role });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;

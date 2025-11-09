
import { PrismaClient, Role, WalletType } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  const now = new Date();
  const adminUid = process.env.ADMIN_UID || 'demo-admin-uid';
  await prisma.user.upsert({
    where: { uid: adminUid },
    update: { role: 'admin' },
    create: { uid: adminUid, role: 'admin' as Role }
  });

  const demoUid = 'demo-user-uid';
  await prisma.user.upsert({
    where: { uid: demoUid },
    update: {},
    create: { uid: demoUid, role: 'user' as Role }
  });

  const w1 = await prisma.wallet.upsert({
    where: { id: '00000000-0000-0000-0000-000000000001' },
    update: {},
    create: { id: '00000000-0000-0000-0000-000000000001', user_id: demoUid, type: 'primary' as WalletType, name: 'Demo Wallet', balance: 10000 }
  });

  await prisma.transaction.create({
    data: { wallet_id: w1.id, amount: 5000, type: 'deposit', status: 'completed', metadata: { seeded: true } }
  });
  await prisma.transaction.create({
    data: { wallet_id: w1.id, amount: -1500, type: 'purchase', status: 'completed', metadata: { item: 'Airtime' } }
  });

  console.log('Seed complete');
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
}).finally(async () => {
  await prisma.$disconnect();
});

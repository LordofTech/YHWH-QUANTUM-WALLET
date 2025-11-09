
import { prisma } from '../database/prisma';

export const TransactionService = {
  createOnline: async (walletId: string, amount: number, type: string, lat?: number, lng?: number, metadata?: any) => {
    return prisma.$transaction(async (tx) => {
      const created = await tx.transaction.create({
        data: { wallet_id: walletId, amount, type, status: 'pending', metadata: metadata || null }
      });
      await tx.wallet.update({ where: { id: walletId }, data: { balance: { increment: amount } } });
      if (lat !== undefined && lng !== undefined) {
        await tx.$executeRawUnsafe(
          `UPDATE transactions SET location = ST_SetSRID(ST_MakePoint($1, $2), 4326) WHERE id = $3`,
          Number(lng), Number(lat), created.id
        );
      }
      return created;
    });
  },

  list: (filters: any, take: number, skip: number) =>
    prisma.transaction.findMany({ where: filters, orderBy: { created_at: 'desc' }, take, skip }),

  nearby: (lng: number, lat: number, radius: number) =>
    prisma.$queryRawUnsafe(
      `SELECT * FROM transactions 
       WHERE location IS NOT NULL AND ST_DWithin(location, ST_MakePoint($1, $2)::geography, $3)
       ORDER BY created_at DESC`,
      Number(lng), Number(lat), Number(radius)
    )
};

import { prisma } from '../database/prisma';
import { $Enums } from '@prisma/client';

const normalizeWalletType = (type?: string): $Enums.WalletType => {
  if (type === 'child') return $Enums.WalletType.child;
  if (type === 'agent') return $Enums.WalletType.agent;
  return $Enums.WalletType.primary; // default
};

export const WalletService = {
  create: (user_id: string, type: string, name?: string) =>
    prisma.wallet.create({
      data: {
        user_id,
        type: normalizeWalletType(type),
        name: name || null,
      },
    }),

  listForUser: (user_id: string) =>
    prisma.wallet.findMany({
      where: { user_id },
      orderBy: { created_at: 'desc' },
    }),

  get: (id: string) =>
    prisma.wallet.findUnique({
      where: { id },
    }),

  transfer: async (fromWalletId: string, toWalletId: string, amount: number) => {
    await prisma.$transaction(async (tx) => {
      const from = await tx.wallet.update({
        where: { id: fromWalletId },
        data: { balance: { decrement: amount } },
      });

      const to = await tx.wallet.update({
        where: { id: toWalletId },
        data: { balance: { increment: amount } },
      });

      await tx.transaction.create({
        data: {
          wallet_id: from.id,
          amount: -Math.abs(amount),
          type: 'transfer_out',
          status: 'completed',
          metadata: { toWalletId } as any,
        },
      });

      await tx.transaction.create({
        data: {
          wallet_id: to.id,
          amount: Math.abs(amount),
          type: 'transfer_in',
          status: 'completed',
          metadata: { fromWalletId } as any,
        },
      });
    });
  },
};

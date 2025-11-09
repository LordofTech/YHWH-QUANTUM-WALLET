-- Enable UUID extension (safe on any Postgres install)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =======================================================
-- ENUM DEFINITIONS
-- =======================================================

-- CreateEnum: Role
CREATE TYPE "Role" AS ENUM ('user', 'agent', 'admin');

-- CreateEnum: WalletType
CREATE TYPE "WalletType" AS ENUM ('primary', 'child', 'agent');

-- =======================================================
-- USER TABLE
-- =======================================================
CREATE TABLE "User" (
    "uid" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'user',
    "email" TEXT,
    "phone" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("uid")
);

-- Add indexes for user identity fields
CREATE UNIQUE INDEX "User_email_key" ON "User" ("email");
CREATE UNIQUE INDEX "User_phone_key" ON "User" ("phone");

-- =======================================================
-- WALLET TABLE
-- =======================================================
CREATE TABLE "Wallet" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),  -- safer alternative
    "user_id" TEXT NOT NULL,
    "type" "WalletType" NOT NULL DEFAULT 'primary',
    "name" TEXT,
    "balance" DECIMAL(65,30) NOT NULL DEFAULT 0.00,
    "currency" TEXT DEFAULT 'NGN',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Wallet_pkey" PRIMARY KEY ("id")
);

-- Foreign key linking Wallet → User
ALTER TABLE "Wallet"
ADD CONSTRAINT "Wallet_user_id_fkey"
FOREIGN KEY ("user_id")
REFERENCES "User" ("uid")
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =======================================================
-- TRANSACTION TABLE
-- =======================================================
CREATE TABLE "Transaction" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "wallet_id" UUID NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "type" TEXT NOT NULL,              -- 'credit' | 'debit'
    "status" TEXT NOT NULL DEFAULT 'pending',
    "reference" TEXT,                  -- optional transaction ref
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- Foreign key linking Transaction → Wallet
ALTER TABLE "Transaction"
ADD CONSTRAINT "Transaction_wallet_id_fkey"
FOREIGN KEY ("wallet_id")
REFERENCES "Wallet" ("id")
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =======================================================
-- LEDGER TABLE (optional future balance tracking)
-- =======================================================
CREATE TABLE "LedgerEntry" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "wallet_id" UUID NOT NULL,
    "tx_id" UUID,
    "amount" DECIMAL(65,30) NOT NULL,
    "direction" TEXT NOT NULL,               -- 'credit' or 'debit'
    "balance_after" DECIMAL(65,30),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LedgerEntry_pkey" PRIMARY KEY ("id")
);

ALTER TABLE "LedgerEntry"
ADD CONSTRAINT "LedgerEntry_wallet_id_fkey"
FOREIGN KEY ("wallet_id")
REFERENCES "Wallet" ("id")
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =======================================================
-- BASIC SEED: create one sample admin user and wallet
-- =======================================================
INSERT INTO "User" ("uid", "role", "email", "phone")
VALUES ('admin-demo', 'admin', 'admin@quantumwallet.africa', '+2348000000000')
ON CONFLICT DO NOTHING;

INSERT INTO "Wallet" ("id", "user_id", "type", "name", "balance", "currency")
VALUES (gen_random_uuid(), 'admin-demo', 'primary', 'Admin Wallet', 100000.00, 'NGN')
ON CONFLICT DO NOTHING;

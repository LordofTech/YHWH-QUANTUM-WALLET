-- Run this in your PostgreSQL to create tables
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE IF NOT EXISTS wallets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id TEXT NOT NULL,
  type TEXT CHECK (type IN ('primary', 'child', 'agent')) NOT NULL,
  name TEXT,
  balance DECIMAL(15,2) DEFAULT 0.00,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  wallet_id UUID REFERENCES wallets(id) ON DELETE CASCADE,
  amount DECIMAL(15,2) NOT NULL,
  type TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  location GEOGRAPHY(POINT, 4326),
  metadata JSONB,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_tx_location ON transactions USING GIST (location);


-- Users for RBAC
CREATE TABLE IF NOT EXISTS users (
  uid TEXT PRIMARY KEY,
  role TEXT CHECK (role IN ('user','agent','admin')) NOT NULL DEFAULT 'user',
  created_at TIMESTAMP DEFAULT NOW()
);

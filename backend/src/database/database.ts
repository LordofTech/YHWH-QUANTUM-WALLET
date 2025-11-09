import { PrismaClient } from '@prisma/client';
import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

// -------------------------------
// 1. Prisma Client (ORM layer)
// -------------------------------
export const prisma = new PrismaClient({
  log: ['query', 'info', 'warn', 'error'], // optional: useful for debugging
});

// -------------------------------
// 2. PostgreSQL Pool (direct SQL or health checks)
// -------------------------------
export const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 5432),
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'TechBro77@$', // ✅ fallback safe
  database: process.env.DB_NAME || 'quantum_wallet',
  ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
});

// -------------------------------
// 3. Connection + Extension Setup
// -------------------------------
export const connectDB = async (): Promise<void> => {
  try {
    const client = await pool.connect();
    console.log('✅ PostgreSQL connected successfully');

    // Ensure required extensions exist
    await client.query(`CREATE EXTENSION IF NOT EXISTS postgis;`);
    await client.query(`CREATE EXTENSION IF NOT EXISTS "uuid-ossp";`);

    client.release();
    console.log('✅ PostGIS & UUID extensions verified');

  } catch (err: any) {
    console.error('❌ DB Connection Error:', err.message);
    process.exit(1); // stop app if DB fails
  }
};

// -------------------------------
// 4. Graceful Shutdown
// -------------------------------
export const closeDB = async (): Promise<void> => {
  try {
    await prisma.$disconnect();
    await pool.end();
    console.log('🛑 Database connections closed');
  } catch (err: any) {
    console.error('⚠️ Error closing DB connections:', err.message);
  }
};

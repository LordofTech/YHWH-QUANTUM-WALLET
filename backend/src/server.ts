import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';
import rateLimit from 'express-rate-limit';
import { startOtel, shutdownOtel } from './observability/otel';
import { pool } from './database/database'; // ✅ Updated path
import authRoutes from './routes/auth.routes';
import syncRoutes from './routes/sync.routes';
import transactionRoutes from './routes/transaction.routes';
import walletRoutes from './routes/wallet.routes';
import adminRoutes from './routes/admin.routes';
import { loadRole } from './middleware/rbac.middleware';
import docsRoutes from './routes/docs.routes';
import { requestId } from './middleware/requestId.middleware';
import { notFound, errorHandler } from './middleware/error.middleware';
import { idempotency } from './middleware/idempotency.middleware';

dotenv.config();
startOtel();

// Graceful shutdown
process.on('SIGTERM', () => {
  shutdownOtel().then(() => process.exit(0));
});
process.on('SIGINT', () => {
  shutdownOtel().then(() => process.exit(0));
});

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(requestId);
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '1mb' }));
app.use(morgan('combined'));
app.use(rateLimit({ windowMs: 15 * 60 * 1000, max: 300 }));

// Health check
app.get('/', (_req, res) => {
  res.json({ message: 'Quantum Wallet Backend - YHWH DEV TEAM', time: new Date().toISOString() });
});

// Docs
app.use('/docs', docsRoutes);

// Routes (with idempotency + RBAC)
app.use('/api/auth', authRoutes);
app.use(loadRole);
app.use('/api/admin', adminRoutes);
app.use('/api/sync', idempotency, syncRoutes);
app.use('/api/tx', idempotency, transactionRoutes);
app.use('/api/wallet', idempotency, walletRoutes);

// Initialize DB (PostgreSQL + PostGIS)
(async () => {
  try {
    const client = await pool.connect();
    console.log('✅ PostgreSQL + PostGIS Connected');

    await client.query(`CREATE EXTENSION IF NOT EXISTS postgis;`);
    await client.query(`CREATE EXTENSION IF NOT EXISTS "uuid-ossp";`);
    client.release();
  } catch (err) {
    console.error('❌ DB Connection Error', err);
  }
})();

// 404 + error handlers
app.use(notFound);
app.use(errorHandler);

// Start Server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});

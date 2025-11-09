
export const config = {
  env: process.env.NODE_ENV || 'development',
  port: Number(process.env.PORT || 3000),
  dbUrl: process.env.DATABASE_URL || '',
  rateLimit: {
    windowMs: 15 * 60 * 1000,
    max: 300
  }
};

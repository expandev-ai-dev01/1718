import sql, { ConnectionPool } from 'mssql';
import { config } from '@/config';

let pool: ConnectionPool;

const dbConfig: sql.config = {
  server: config.database.server,
  port: config.database.port,
  user: config.database.user,
  password: config.database.password,
  database: config.database.database,
  options: {
    encrypt: config.database.options.encrypt,
    trustServerCertificate: config.database.options.trustServerCertificate,
  },
  pool: {
    max: config.database.pool.max,
    min: config.database.pool.min,
    idleTimeoutMillis: config.database.pool.idleTimeoutMillis,
  },
};

/**
 * @summary
 * Establishes a connection pool to the SQL Server database.
 *
 * @throws {Error} If the connection fails.
 */
export async function connectToDatabase(): Promise<void> {
  try {
    pool = await new ConnectionPool(dbConfig).connect();
    console.log('Connected to SQL Server');
  } catch (err) {
    console.error('Database Connection Failed!', err);
    throw err;
  }
}

/**
 * @summary
 * Retrieves the active database connection pool.
 *
 * @returns {ConnectionPool} The active connection pool.
 * @throws {Error} If the pool is not initialized.
 */
export function getPool(): ConnectionPool {
  if (!pool) {
    throw new Error('Database pool not initialized. Call connectToDatabase first.');
  }
  return pool;
}

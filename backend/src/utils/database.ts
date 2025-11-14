import sql, { ConnectionPool, IRecordSet, Request } from 'mssql';
import { config } from '@/config';

let pool: ConnectionPool;

const dbConfig = {
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
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
};

export const getPool = async (): Promise<ConnectionPool> => {
  if (pool && pool.connected) {
    return pool;
  }
  try {
    pool = await new ConnectionPool(dbConfig).connect();
    console.log('Database connection pool created successfully.');

    pool.on('error', (err) => {
      console.error('Database Pool Error:', err);
      // Optionally try to close and re-establish the pool
    });

    return pool;
  } catch (err) {
    console.error('Database connection failed:', err);
    throw new Error('Failed to establish database connection.');
  }
};

export enum ExpectedReturn {
  Single,
  Multi,
  None,
}

/**
 * @summary Executes a stored procedure with the given parameters.
 * @param routine The name of the stored procedure to execute (e.g., '[schema].[spName]').
 * @param parameters An object containing the parameters for the stored procedure.
 * @param expectedReturn The expected return type from the procedure.
 * @returns The result from the database operation.
 */
export async function dbRequest(
  routine: string,
  parameters: Record<string, any>,
  expectedReturn: ExpectedReturn
): Promise<any> {
  try {
    const pool = await getPool();
    const request: Request = pool.request();

    for (const key in parameters) {
      if (Object.prototype.hasOwnProperty.call(parameters, key)) {
        request.input(key, parameters[key]);
      }
    }

    const result = await request.execute(routine);

    switch (expectedReturn) {
      case ExpectedReturn.Single:
        return result.recordset[0] || null;
      case ExpectedReturn.Multi:
        return result.recordsets as IRecordSet<any>[];
      case ExpectedReturn.None:
        return;
      default:
        return result.recordset;
    }
  } catch (error) {
    console.error(`Error executing stored procedure ${routine}:`, error);
    // Re-throw the error to be handled by the service layer
    throw error;
  }
}

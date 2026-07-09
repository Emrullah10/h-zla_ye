import pg from 'pg';
import util from './util.js';

// Private instance holder
let instance = {};
const execute = async (client, script, parameters) => {
  if (!client) {
    throw new Error('Database connection not initialized');
  }
  try {
    return await client.query(script, parameters);
  } catch (err) {
    console.error('Query error:', err.message, { script, parameters });
    throw err;
  }
};
/**
 * Creates a PostgreSQL connector instance
 * @returns {Object} PostgreSQL connector instance
 * Pg Settings:
 * let Config = {
  user: string, // default process.env.PGUSER || process.env.USER
  password: string or function, //default process.env.PGPASSWORD
  host: string, // default process.env.PGHOST
  port: number, // default process.env.PGPORT
  database: string, // default process.env.PGDATABASE || user
  connectionString: string, // e.g. postgres://user:password@host:5432/database
  ssl: any, // passed directly to node.TLSSocket, supports all tls.connect options
  types: any, // custom type parsers
  statement_timeout: number, // number of milliseconds before a statement in query will time out, default is no timeout
  query_timeout: number, // number of milliseconds before a query call will timeout, default is no timeout
  lock_timeout: number, // number of milliseconds a query is allowed to be en lock state before it's cancelled due to lock timeout
  application_name: string, // The name of the application that created this Client instance
  connectionTimeoutMillis: number, // number of milliseconds to wait for connection, default is no timeout
  idle_in_transaction_session_timeout: number // number of milliseconds before terminating any session with an open idle transaction, default is no timeout
}
 */
function createConnector(settings, applicationName) {
  // Private variables
  let pool = null;
  let connectorName = null;
  let connectorType = null;
  const init = (settings, applicationName) => {
    const { name, type, ...pgOptions } = settings;
    connectorName = name;
    connectorType = type;

    const dbConfig = {
      ...pgOptions,
      application_name: applicationName,
      max: pgOptions.max || 30,
    };

    pool = new pg.Pool(dbConfig);
    pool.on('error', (err) => {
      console.error(`${connectorName} Error on Postgre Pool`, err);
    });
  };

  const connector = {
    get name() {
      return connectorName;
    },
    get type() {
      return connectorType;
    },

    async health() {
      try {
        const result = await this.query('SELECT 1 AS result');
        return util.health(this, result?.rows?.length > 0);
      } catch (err) {
        console.error(`${connectorName} health check failed`, err.message);
        return util.health(this, false);
      }
    },

    /**
     * Execute a database query
     * @param {string} script - SQL query to execute
     * @param {Array} parameter - Query parameters
     * @returns {Promise} Query result
     */
    query(script, parameters) {
      return execute(pool, script, parameters);
    },

    /**
     * Begin a new transaction
     * @returns {Promise<Object>} Transaction client
     */
    async beginTransaction() {
      if (!pool) {
        throw new Error('Database connection not initialized');
      }

      const client = await pool.connect();
      await client.query('BEGIN');

      return {
        /**
         * Execute a query within the transaction
         * @param {string} script - SQL query
         * @param {Array} parameters - Query parameters
         * @returns {Promise} Query result
         */
        async query(script, parameters) {
          return execute(client, script, parameters);
        },

        /**
         * Commit the transaction
         * @returns {Promise}
         */
        async commit() {
          try {
            await client.query('COMMIT');
          } finally {
            client.release();
          }
        },

        /**
         * Rollback the transaction
         * @returns {Promise}
         */
        async rollback() {
          try {
            await client.query('ROLLBACK');
          } finally {
            client.release();
          }
        },
      };
    },

    /**
     * Execute queries within a transaction
     * @param {Function} callback - Function that receives transaction client and executes queries
     * @returns {Promise} Result of the transaction
     */
    async executeTransaction(callback) {
      const transaction = await this.beginTransaction();

      try {
        const result = await callback(transaction);
        await transaction.commit();
        return result;
      } catch (err) {
        await transaction.rollback();
        throw err;
      }
    },

    // Getter methods for private variables
    getPool() {
      return pool;
    },

    getName() {
      return connectorName;
    },

    async disconnect() {
      if (pool) {
        await pool.end();
      }
    },
  };
  init(settings, applicationName);
  return Object.freeze(connector);
}

/**
 * Get or create the PostgreSQL connector singleton instance
 * @returns {Object} Frozen connector instance
 */
export default function Postgre(settings, applicationName) {
  let { name } = settings;
  if (!instance[name]) {
    let connector = createConnector(settings, applicationName);

    instance[name] = connector;
  }
  return instance[name];
}

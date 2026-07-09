import pg from 'pg';

const TEST_CONNECTION = 'postgres://emrullah@localhost:5432/hizla_dev';
const SEARCH_PATH = 'auth,shared';

let pool = null;

export function getTestDb() {
  if (!pool) {
    pool = new pg.Pool({
      connectionString: TEST_CONNECTION,
      options: `-c search_path=${SEARCH_PATH}`,
      max: 5,
    });
  }
  return {
    query: (script, parameters) => pool.query(script, parameters),
  };
}

export async function cleanTestUsers(phones = []) {
  if (!phones.length) return;
  const placeholders = phones.map((_, i) => `$${i + 1}`).join(', ');
  await pool.query(`DELETE FROM auth.users WHERE user_phone IN (${placeholders})`, phones);
}

export async function closeTestDb() {
  if (pool) {
    await pool.end();
    pool = null;
  }
}

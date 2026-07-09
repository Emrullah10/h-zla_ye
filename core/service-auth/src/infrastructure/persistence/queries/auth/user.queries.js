import { TABLES } from '../../schemas/table-definitions.js';

export const findByPhone = (phone) => ({
  text: `SELECT user_id, user_phone, user_password_hash, user_role FROM ${TABLES.USERS} WHERE user_phone = $1`,
  values: [phone],
});

export const findById = (userId) => ({
  text: `SELECT user_id, user_phone, user_password_hash, user_role FROM ${TABLES.USERS} WHERE user_id = $1`,
  values: [userId],
});

import { UserRepository } from '../../../domain/user/user.repository.js';
import { User } from '../../../domain/user/user.entity.js';
import * as queries from '../queries/auth/user.queries.js';

export class UserRepositoryImpl extends UserRepository {
  constructor(db) {
    super();
    this.db = db;
  }

  async findByPhone(phone) {
    const result = await this.db.query(queries.findByPhone(phone));
    if (!result.rows.length) return null;
    const row = result.rows[0];
    return new User({
      userId: row.user_id,
      phone: row.user_phone,
      passwordHash: row.user_password_hash,
      role: row.user_role,
    });
  }

  async findById(userId) {
    const result = await this.db.query(queries.findById(userId));
    if (!result.rows.length) return null;
    const row = result.rows[0];
    return new User({
      userId: row.user_id,
      phone: row.user_phone,
      passwordHash: row.user_password_hash,
      role: row.user_role,
    });
  }
}

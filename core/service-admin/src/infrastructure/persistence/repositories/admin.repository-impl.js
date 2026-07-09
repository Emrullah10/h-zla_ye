import * as q from '../queries/admin/admin.queries.js';

export class DashboardRepositoryImpl {
  constructor(db) { this.db = db; }

  async getStats() {
    const res = await this.db.query(q.getDashboardStats());
    const row = res.rows[0];
    return {
      activeCouriers: parseInt(row.active_couriers, 10),
      todayOrders: parseInt(row.today_orders, 10),
      dailyRevenue: parseFloat(row.daily_revenue),
      pendingApprovals: parseInt(row.pending_approvals, 10),
    };
  }
}

export class DriverRepositoryImpl {
  constructor(db) { this.db = db; }

  async findPending() {
    const res = await this.db.query(q.findPendingApplications());
    return res.rows.map((row) => ({
      appId: row.app_id, userId: row.user_id, status: row.status,
      vehicleType: row.vehicle_type, phone: row.user_phone, createdAt: row.created_at,
    }));
  }

  async findApplicationById(appId) {
    const res = await this.db.query(q.findApplicationById(appId));
    if (!res.rows.length) return null;
    const row = res.rows[0];
    return { appId: row.app_id, userId: row.user_id, status: row.status, vehicleType: row.vehicle_type };
  }

  async approveApplication(appId, adminId) {
    const res = await this.db.query(q.approveApplication(appId));
    const row = res.rows[0];
    const app = { appId: row.app_id, userId: row.user_id, status: row.status, vehicleType: row.vehicle_type };

    // courier + wallet oluştur
    const userRes = await this.db.query({
      text: 'SELECT user_phone FROM auth.users WHERE user_id = $1',
      values: [app.userId],
    });
    const phone = userRes.rows[0]?.user_phone ?? '';
    const courierRes = await this.db.query(q.createCourierForApprovedUser({
      userId: app.userId, phone, vehicleType: app.vehicleType ?? 'motorcycle',
    }));
    if (courierRes.rows.length) {
      await this.db.query(q.createWalletForCourier(courierRes.rows[0].courier_id));
    }
    return app;
  }

  async rejectApplication(appId) {
    const res = await this.db.query(q.rejectApplication(appId));
    const row = res.rows[0];
    return { appId: row.app_id, userId: row.user_id, status: row.status, vehicleType: row.vehicle_type };
  }
}

export class AdminActionRepositoryImpl {
  constructor(db) { this.db = db; }

  async log(data) {
    await this.db.query(q.logAdminAction(data));
  }
}

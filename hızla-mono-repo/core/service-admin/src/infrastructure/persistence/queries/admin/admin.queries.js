import { TABLES } from '../../schemas/table-definitions.js';

export const getDashboardStats = () => ({
  text: `SELECT
    (SELECT COUNT(*) FROM ${TABLES.COURIERS} WHERE status = 'online') AS active_couriers,
    (SELECT COUNT(*) FROM ${TABLES.ORDERS} WHERE created_at::date = CURRENT_DATE) AS today_orders,
    (SELECT COALESCE(SUM(fee), 0) FROM ${TABLES.ORDERS} WHERE created_at::date = CURRENT_DATE AND status = 'delivered') AS daily_revenue,
    (SELECT COUNT(*) FROM ${TABLES.APPLICATIONS} WHERE status = 'training_complete') AS pending_approvals`,
  values: [],
});

export const findPendingApplications = () => ({
  text: `SELECT a.app_id, a.user_id, a.status, a.vehicle_type, a.created_at,
                u.user_phone
         FROM ${TABLES.APPLICATIONS} a
         JOIN ${TABLES.USERS} u ON u.user_id = a.user_id
         WHERE a.status = 'training_complete'
         ORDER BY a.created_at`,
  values: [],
});

export const findApplicationById = (appId) => ({
  text: `SELECT app_id, user_id, status, vehicle_type FROM ${TABLES.APPLICATIONS} WHERE app_id = $1`,
  values: [appId],
});

export const approveApplication = (appId) => ({
  text: `UPDATE ${TABLES.APPLICATIONS} SET status = 'approved', updated_at = NOW()
         WHERE app_id = $1
         RETURNING app_id, user_id, status, vehicle_type`,
  values: [appId],
});

export const rejectApplication = (appId) => ({
  text: `UPDATE ${TABLES.APPLICATIONS} SET status = 'rejected', updated_at = NOW()
         WHERE app_id = $1
         RETURNING app_id, user_id, status, vehicle_type`,
  values: [appId],
});

export const logAdminAction = ({ adminId, actionType, targetId, notes }) => ({
  text: `INSERT INTO ${TABLES.ADMIN_ACTIONS} (admin_id, action_type, target_id, notes)
         VALUES ($1, $2, $3, $4)`,
  values: [adminId, actionType, targetId, notes ?? null],
});

export const createCourierForApprovedUser = ({ userId, phone, vehicleType }) => ({
  text: `INSERT INTO ${TABLES.COURIERS} (courier_user_id, name, phone, vehicle_type)
         VALUES ($1, $2, $3, $4)
         ON CONFLICT (courier_user_id) DO NOTHING
         RETURNING courier_id`,
  values: [userId, phone, vehicleType],
});

export const createWalletForCourier = (courierId) => ({
  text: `INSERT INTO ${TABLES.WALLET} (courier_id) VALUES ($1) ON CONFLICT DO NOTHING`,
  values: [courierId],
});

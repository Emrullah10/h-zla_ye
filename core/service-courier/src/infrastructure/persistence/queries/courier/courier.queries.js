import { TABLES } from '../../schemas/table-definitions.js';

export const findByUserId = (userId) => ({
  text: `SELECT courier_id, courier_user_id, name, phone, status, vehicle_type, rating
         FROM ${TABLES.COURIERS} WHERE courier_user_id = $1`,
  values: [userId],
});

export const findById = (courierId) => ({
  text: `SELECT courier_id, courier_user_id, name, phone, status, vehicle_type, rating
         FROM ${TABLES.COURIERS} WHERE courier_id = $1`,
  values: [courierId],
});

export const findActiveByCourierId = (courierId) => ({
  text: `SELECT order_id, courier_id, restaurant_name, pickup_addr, delivery_addr,
                status, amount, fee, distance_meters, qr_code, created_at, updated_at
         FROM ${TABLES.ORDERS}
         WHERE courier_id = $1 AND status IN ('accepted', 'picked_up')
         ORDER BY updated_at DESC LIMIT 1`,
  values: [courierId],
});

export const findOrderById = (orderId) => ({
  text: `SELECT order_id, courier_id, restaurant_name, pickup_addr, delivery_addr,
                status, amount, fee, distance_meters, qr_code, created_at, updated_at
         FROM ${TABLES.ORDERS} WHERE order_id = $1`,
  values: [orderId],
});

export const updateOrderStatus = (orderId, status) => ({
  text: `UPDATE ${TABLES.ORDERS} SET status = $2, updated_at = NOW()
         WHERE order_id = $1
         RETURNING order_id, courier_id, restaurant_name, pickup_addr, delivery_addr,
                   status, amount, fee, distance_meters, qr_code, created_at, updated_at`,
  values: [orderId, status],
});

export const createRating = ({ orderId, courierId, restaurantRating, comment }) => ({
  text: `INSERT INTO ${TABLES.ORDER_RATINGS} (order_id, courier_id, restaurant_rating, comment)
         VALUES ($1, $2, $3, $4)
         RETURNING rating_id, order_id, courier_id, restaurant_rating, comment, created_at`,
  values: [orderId, courierId, restaurantRating, comment],
});

export const findWalletByCourierId = (courierId) => ({
  text: `SELECT wallet_id, courier_id, balance, pending, updated_at
         FROM ${TABLES.WALLET} WHERE courier_id = $1`,
  values: [courierId],
});

export const findTransactionsByCourierId = (courierId) => ({
  text: `SELECT tx_id, courier_id, order_id, amount, type, description, created_at
         FROM ${TABLES.TRANSACTIONS} WHERE courier_id = $1
         ORDER BY created_at DESC LIMIT 50`,
  values: [courierId],
});

export const getWeeklyEarnings = (courierId) => ({
  text: `SELECT
           COALESCE(SUM(amount), 0) AS total,
           COUNT(*) AS order_count,
           COALESCE(AVG(amount), 0) AS avg_order_fee
         FROM ${TABLES.TRANSACTIONS}
         WHERE courier_id = $1
           AND type = 'credit'
           AND created_at >= NOW() - INTERVAL '7 days'`,
  values: [courierId],
});

export const getWeeklyBars = (courierId) => ({
  text: `SELECT TO_CHAR(created_at, 'Dy') AS label, COALESCE(SUM(amount), 0) AS amount
         FROM ${TABLES.TRANSACTIONS}
         WHERE courier_id = $1 AND type = 'credit' AND created_at >= NOW() - INTERVAL '7 days'
         GROUP BY TO_CHAR(created_at, 'Dy'), DATE_TRUNC('day', created_at)
         ORDER BY DATE_TRUNC('day', created_at)`,
  values: [courierId],
});

export const getMonthlyEarnings = (courierId) => ({
  text: `SELECT
           COALESCE(SUM(amount), 0) AS total,
           COUNT(*) AS order_count,
           COALESCE(AVG(amount), 0) AS avg_order_fee
         FROM ${TABLES.TRANSACTIONS}
         WHERE courier_id = $1
           AND type = 'credit'
           AND created_at >= NOW() - INTERVAL '30 days'`,
  values: [courierId],
});

export const getMonthlyBars = (courierId) => ({
  text: `SELECT 'Hf' || CEIL(EXTRACT(DOY FROM created_at) / 7.0) AS label,
                COALESCE(SUM(amount), 0) AS amount
         FROM ${TABLES.TRANSACTIONS}
         WHERE courier_id = $1 AND type = 'credit' AND created_at >= NOW() - INTERVAL '30 days'
         GROUP BY CEIL(EXTRACT(DOY FROM created_at) / 7.0)
         ORDER BY CEIL(EXTRACT(DOY FROM created_at) / 7.0)`,
  values: [courierId],
});

export const findQuestsByCourierId = (courierId) => ({
  text: `SELECT q.quest_id, q.title, q.description, q.reward, q.target_count, q.rarity, q.expires_at,
                COALESCE(cq.progress, 0) AS progress, cq.completed_at
         FROM ${TABLES.QUESTS} q
         LEFT JOIN ${TABLES.COURIER_QUESTS} cq ON cq.quest_id = q.quest_id AND cq.courier_id = $1
         WHERE q.expires_at IS NULL OR q.expires_at > NOW()
         ORDER BY q.rarity DESC, q.created_at`,
  values: [courierId],
});

export const createSupportTicket = ({ courierId, category, subject, message }) => ({
  text: `INSERT INTO ${TABLES.SUPPORT_TICKETS} (courier_id, category, subject, message)
         VALUES ($1, $2, $3, $4)
         RETURNING ticket_id, courier_id, category, subject, message, status, created_at`,
  values: [courierId, category, subject, message],
});

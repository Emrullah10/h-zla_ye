import * as q from '../queries/courier/courier.queries.js';

function mapCourier(row) {
  return {
    courierId: row.courier_id,
    userId: row.courier_user_id,
    name: row.name,
    phone: row.phone,
    status: row.status,
    vehicleType: row.vehicle_type,
    rating: row.rating,
  };
}

function mapOrder(row) {
  return {
    orderId: row.order_id,
    courierId: row.courier_id,
    restaurantName: row.restaurant_name,
    pickupAddr: row.pickup_addr,
    deliveryAddr: row.delivery_addr,
    status: row.status,
    amount: row.amount,
    fee: row.fee,
    distanceMeters: row.distance_meters,
    qrCode: row.qr_code,
    createdAt: row.created_at,
    updatedAt: row.updated_at,
  };
}

export class CourierRepositoryImpl {
  constructor(db) { this.db = db; }

  async findByUserId(userId) {
    const res = await this.db.query(q.findByUserId(userId));
    return res.rows.length ? mapCourier(res.rows[0]) : null;
  }

  async findById(courierId) {
    const res = await this.db.query(q.findById(courierId));
    return res.rows.length ? mapCourier(res.rows[0]) : null;
  }
}

export class OrderRepositoryImpl {
  constructor(db) { this.db = db; }

  async findActiveByCourierId(courierId) {
    const res = await this.db.query(q.findActiveByCourierId(courierId));
    return res.rows.length ? mapOrder(res.rows[0]) : null;
  }

  async findById(orderId) {
    const res = await this.db.query(q.findOrderById(orderId));
    return res.rows.length ? mapOrder(res.rows[0]) : null;
  }

  async updateStatus(orderId, status) {
    const res = await this.db.query(q.updateOrderStatus(orderId, status));
    return mapOrder(res.rows[0]);
  }
}

export class RatingRepositoryImpl {
  constructor(db) { this.db = db; }

  async create(data) {
    const res = await this.db.query(q.createRating(data));
    const row = res.rows[0];
    return {
      ratingId: row.rating_id,
      orderId: row.order_id,
      courierId: row.courier_id,
      restaurantRating: row.restaurant_rating,
      comment: row.comment,
      createdAt: row.created_at,
    };
  }
}

export class WalletRepositoryImpl {
  constructor(db) { this.db = db; }

  async findByCourierId(courierId) {
    const res = await this.db.query(q.findWalletByCourierId(courierId));
    if (!res.rows.length) return null;
    const row = res.rows[0];
    return { walletId: row.wallet_id, courierId: row.courier_id, balance: row.balance, pending: row.pending };
  }

  async findTransactions(courierId) {
    const res = await this.db.query(q.findTransactionsByCourierId(courierId));
    return res.rows.map((row) => ({
      txId: row.tx_id,
      courierId: row.courier_id,
      orderId: row.order_id,
      amount: row.amount,
      type: row.type,
      description: row.description,
      createdAt: row.created_at,
    }));
  }
}

export class EarningsRepositoryImpl {
  constructor(db) { this.db = db; }

  async getEarnings(courierId, period) {
    const isWeekly = period === 'weekly';
    const [summaryRes, barsRes] = await Promise.all([
      this.db.query(isWeekly ? q.getWeeklyEarnings(courierId) : q.getMonthlyEarnings(courierId)),
      this.db.query(isWeekly ? q.getWeeklyBars(courierId) : q.getMonthlyBars(courierId)),
    ]);
    const s = summaryRes.rows[0];
    return {
      total: parseFloat(s.total),
      orderCount: parseInt(s.order_count, 10),
      avgOrderFee: parseFloat(s.avg_order_fee),
      onlineHours: 0,
      bars: barsRes.rows.map((r) => ({ label: r.label, amount: parseFloat(r.amount) })),
    };
  }
}

export class QuestRepositoryImpl {
  constructor(db) { this.db = db; }

  async findByCourierId(courierId) {
    const res = await this.db.query(q.findQuestsByCourierId(courierId));
    return res.rows.map((row) => ({
      questId: row.quest_id,
      title: row.title,
      description: row.description,
      reward: row.reward,
      targetCount: row.target_count,
      rarity: row.rarity,
      expiresAt: row.expires_at,
      progress: parseInt(row.progress, 10),
      completedAt: row.completed_at,
    }));
  }
}

export class SupportRepositoryImpl {
  constructor(db) { this.db = db; }

  async create(data) {
    const res = await this.db.query(q.createSupportTicket(data));
    const row = res.rows[0];
    return {
      ticketId: row.ticket_id,
      courierId: row.courier_id,
      category: row.category,
      subject: row.subject,
      message: row.message,
      status: row.status,
      createdAt: row.created_at,
    };
  }
}

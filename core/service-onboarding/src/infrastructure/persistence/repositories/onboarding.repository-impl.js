import * as q from '../queries/onboarding/onboarding.queries.js';

function mapApp(row) {
  return { appId: row.app_id, userId: row.user_id, status: row.status, vehicleType: row.vehicle_type };
}

export class ApplicationRepositoryImpl {
  constructor(db) { this.db = db; }

  async findByUserId(userId) {
    const res = await this.db.query(q.findApplicationByUserId(userId));
    return res.rows.length ? mapApp(res.rows[0]) : null;
  }

  async create({ userId }) {
    const res = await this.db.query(q.createApplication(userId));
    return mapApp(res.rows[0]);
  }

  async updateStatus(appId, status) {
    const res = await this.db.query(q.updateApplicationStatus(appId, status));
    return mapApp(res.rows[0]);
  }

  async updateVehicle(appId, vehicleType) {
    const res = await this.db.query(q.updateApplicationVehicle(appId, vehicleType));
    return mapApp(res.rows[0]);
  }
}

export class DocumentRepositoryImpl {
  constructor(db) { this.db = db; }

  async create({ appId, type, filePath }) {
    const res = await this.db.query(q.createDocument({ appId, type, filePath }));
    const row = res.rows[0];
    return { docId: row.doc_id, appId: row.app_id, type: row.type, filePath: row.file_path, status: row.status };
  }

  async findByAppId(appId) {
    const res = await this.db.query(q.findDocumentsByAppId(appId));
    return res.rows.map((row) => ({
      docId: row.doc_id, appId: row.app_id, type: row.type, filePath: row.file_path, status: row.status,
    }));
  }
}

export class TrainingRepositoryImpl {
  constructor(db) { this.db = db; }

  async create(appId) {
    const res = await this.db.query(q.createTrainingCompletion(appId));
    const row = res.rows[0];
    return { tcId: row.tc_id, appId: row.app_id, completedAt: row.completed_at };
  }

  async findByAppId(appId) {
    const res = await this.db.query(q.findTrainingByAppId(appId));
    return res.rows.length ? { tcId: res.rows[0].tc_id, appId: res.rows[0].app_id } : null;
  }
}

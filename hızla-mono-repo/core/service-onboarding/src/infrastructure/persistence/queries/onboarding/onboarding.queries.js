import { TABLES } from '../../schemas/table-definitions.js';

export const findApplicationByUserId = (userId) => ({
  text: `SELECT app_id, user_id, status, vehicle_type, created_at, updated_at
         FROM ${TABLES.APPLICATIONS} WHERE user_id = $1`,
  values: [userId],
});

export const createApplication = (userId) => ({
  text: `INSERT INTO ${TABLES.APPLICATIONS} (user_id, status)
         VALUES ($1, 'pending')
         RETURNING app_id, user_id, status, vehicle_type, created_at, updated_at`,
  values: [userId],
});

export const updateApplicationStatus = (appId, status) => ({
  text: `UPDATE ${TABLES.APPLICATIONS} SET status = $2, updated_at = NOW()
         WHERE app_id = $1
         RETURNING app_id, user_id, status, vehicle_type, created_at, updated_at`,
  values: [appId, status],
});

export const updateApplicationVehicle = (appId, vehicleType) => ({
  text: `UPDATE ${TABLES.APPLICATIONS} SET vehicle_type = $2, updated_at = NOW()
         WHERE app_id = $1
         RETURNING app_id, user_id, status, vehicle_type, created_at, updated_at`,
  values: [appId, vehicleType],
});

export const createDocument = ({ appId, type, filePath }) => ({
  text: `INSERT INTO ${TABLES.DOCUMENTS} (app_id, type, file_path, status)
         VALUES ($1, $2, $3, 'pending')
         RETURNING doc_id, app_id, type, file_path, status, created_at`,
  values: [appId, type, filePath],
});

export const findDocumentsByAppId = (appId) => ({
  text: `SELECT doc_id, app_id, type, file_path, status, created_at, updated_at
         FROM ${TABLES.DOCUMENTS} WHERE app_id = $1`,
  values: [appId],
});

export const createTrainingCompletion = (appId) => ({
  text: `INSERT INTO ${TABLES.TRAINING_COMPLETIONS} (app_id)
         VALUES ($1)
         RETURNING tc_id, app_id, completed_at`,
  values: [appId],
});

export const findTrainingByAppId = (appId) => ({
  text: `SELECT tc_id, app_id, completed_at FROM ${TABLES.TRAINING_COMPLETIONS} WHERE app_id = $1`,
  values: [appId],
});

import express from 'express';
import multer from 'multer';
import path from 'path';
import { mkdirSync } from 'fs';
import onboardingController from '../src/interfaces/http/onboarding.controller.js';
import { requireAuth } from '../src/shared/utils/auth-middleware.js';
import appConfig from '@hizla/config/index.js';

function createUpload() {
  const uploadDir = appConfig?.uploadDir ?? './uploads';
  const maxSize = (appConfig?.uploadMaxFileSizeMb ?? 10) * 1024 * 1024;
  mkdirSync(uploadDir, { recursive: true });

  const storage = multer.diskStorage({
    destination: (_req, _file, cb) => cb(null, uploadDir),
    filename: (_req, file, cb) => {
      const ext = path.extname(file.originalname);
      cb(null, `${Date.now()}-${Math.random().toString(36).slice(2)}${ext}`);
    },
  });

  return multer({ storage, limits: { fileSize: maxSize } });
}

export default (serviceAppConfig) => {
  const router = express.Router();
  const auth = requireAuth();
  const ctrl = onboardingController(serviceAppConfig);
  const upload = createUpload();

  router.get('/api/onboarding/status', auth, ctrl.getStatus);
  router.post('/api/onboarding/vehicle', auth, ctrl.selectVehicle);
  router.post('/api/onboarding/document', auth, upload.single('file'), ctrl.uploadDocument);
  router.post('/api/onboarding/training/complete', auth, ctrl.completeTraining);

  router.get('/app/health', (_req, res) => res.json({ status: 'ok', service: 'service-onboarding' }));

  return router;
};

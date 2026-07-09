import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeApplicationRepo, makeFakeDocumentRepo, makeFakeTrainingRepo } from '../../helpers/index.js';
import createGetStatusUseCase from '#core/application/use-cases/onboarding/get-status.use-case.js';

describe('get-onboarding-status use-case', () => {
  it('başvuru yoksa pending döner', async () => {
    const getStatus = createGetStatusUseCase({
      applicationRepository: makeFakeApplicationRepo({ async findByUserId() { return null; } }),
      documentRepository: makeFakeDocumentRepo(),
      trainingRepository: makeFakeTrainingRepo(),
    });
    const result = await getStatus({ userId: 'u-001' });
    assert.equal(result.status, 'pending');
    assert.equal(result.appId, null);
  });

  it('başvuru varsa status ve belgeler döner', async () => {
    const app = { appId: 'app-001', userId: 'u-001', status: 'documents_uploaded', vehicleType: 'motorcycle' };
    const docs = [{ docId: 'd-001', type: 'id_front', status: 'pending' }];
    const getStatus = createGetStatusUseCase({
      applicationRepository: makeFakeApplicationRepo({ async findByUserId() { return app; } }),
      documentRepository: makeFakeDocumentRepo({ async findByAppId() { return docs; } }),
      trainingRepository: makeFakeTrainingRepo(),
    });
    const result = await getStatus({ userId: 'u-001' });
    assert.equal(result.status, 'documents_uploaded');
    assert.equal(result.appId, 'app-001');
    assert.equal(result.documents.length, 1);
  });
});

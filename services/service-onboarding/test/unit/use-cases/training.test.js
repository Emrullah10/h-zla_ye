import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeApplicationRepo, makeFakeTrainingRepo } from '../../helpers/index.js';
import createCompleteTrainingUseCase from '#core/application/use-cases/onboarding/complete-training.use-case.js';

describe('complete-training use-case', () => {
  it('başvuru yoksa 404 fırlatır', async () => {
    const complete = createCompleteTrainingUseCase({
      applicationRepository: makeFakeApplicationRepo({ async findByUserId() { return null; } }),
      trainingRepository: makeFakeTrainingRepo(),
    });
    await assert.rejects(
      () => complete({ userId: 'u-001' }),
      (err) => { assert.equal(err.statusCode, 404); return true; },
    );
  });

  it('eğitim zaten tamamlanmışsa 400 fırlatır', async () => {
    const app = { appId: 'app-001', userId: 'u-001', status: 'training_complete' };
    const complete = createCompleteTrainingUseCase({
      applicationRepository: makeFakeApplicationRepo({ async findByUserId() { return app; } }),
      trainingRepository: makeFakeTrainingRepo({ async findByAppId() { return { tcId: 'tc-001' }; } }),
    });
    await assert.rejects(
      () => complete({ userId: 'u-001' }),
      (err) => { assert.equal(err.statusCode, 400); return true; },
    );
  });

  it('eğitim tamamlanır ve status güncellenir', async () => {
    let statusUpdated = null;
    const app = { appId: 'app-001', userId: 'u-001', status: 'documents_uploaded' };
    const complete = createCompleteTrainingUseCase({
      applicationRepository: makeFakeApplicationRepo({
        async findByUserId() { return app; },
        async updateStatus(appId, status) { statusUpdated = status; return { ...app, status }; },
      }),
      trainingRepository: makeFakeTrainingRepo({
        async findByAppId() { return null; },
        async create(appId) { return { tcId: 'tc-001', appId }; },
      }),
    });
    await complete({ userId: 'u-001' });
    assert.equal(statusUpdated, 'training_complete');
  });
});

import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeApplicationRepo, makeFakeDocumentRepo } from '../../helpers/index.js';
import createUploadDocumentUseCase from '#core/application/use-cases/onboarding/upload-document.use-case.js';

const activeApp = { appId: 'app-001', userId: 'u-001', status: 'pending' };

describe('upload-document use-case', () => {
  it('başvuru yoksa 404 fırlatır', async () => {
    const upload = createUploadDocumentUseCase({
      applicationRepository: makeFakeApplicationRepo({ async findByUserId() { return null; } }),
      documentRepository: makeFakeDocumentRepo(),
    });
    await assert.rejects(
      () => upload({ userId: 'u-001', docType: 'id_front', filePath: '/uploads/file.jpg' }),
      (err) => { assert.equal(err.statusCode, 404); return true; },
    );
  });

  it('geçersiz docType 400 fırlatır', async () => {
    const upload = createUploadDocumentUseCase({
      applicationRepository: makeFakeApplicationRepo({ async findByUserId() { return activeApp; } }),
      documentRepository: makeFakeDocumentRepo(),
    });
    await assert.rejects(
      () => upload({ userId: 'u-001', docType: 'selfie', filePath: '/uploads/file.jpg' }),
      (err) => { assert.equal(err.statusCode, 400); return true; },
    );
  });

  it('belge kaydedilir ve döner', async () => {
    let saved = null;
    const upload = createUploadDocumentUseCase({
      applicationRepository: makeFakeApplicationRepo({ async findByUserId() { return activeApp; } }),
      documentRepository: makeFakeDocumentRepo({
        async create(data) { saved = data; return { docId: 'd-001', ...data }; },
      }),
    });
    const result = await upload({ userId: 'u-001', docType: 'id_front', filePath: '/uploads/file.jpg' });
    assert.equal(saved.type, 'id_front');
    assert.equal(saved.appId, 'app-001');
    assert.ok(result.docId);
  });
});

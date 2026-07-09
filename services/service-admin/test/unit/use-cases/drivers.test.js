import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeDriverRepo, makeFakeAdminActionRepo } from '../../helpers/index.js';
import createGetDriversUseCase from '#core/application/use-cases/admin/get-drivers.use-case.js';
import createApproveDriverUseCase from '#core/application/use-cases/admin/approve-driver.use-case.js';
import createRejectDriverUseCase from '#core/application/use-cases/admin/reject-driver.use-case.js';

describe('get-drivers use-case', () => {
  it('onay bekleyen sürücüleri döner', async () => {
    const drivers = [
      { appId: 'app-001', userId: 'u-001', status: 'training_complete' },
    ];
    const getDrivers = createGetDriversUseCase({
      driverRepository: makeFakeDriverRepo({ async findPending() { return drivers; } }),
    });
    const result = await getDrivers();
    assert.equal(result.drivers.length, 1);
  });

  it('bekleyen sürücü yoksa boş liste döner', async () => {
    const getDrivers = createGetDriversUseCase({
      driverRepository: makeFakeDriverRepo({ async findPending() { return []; } }),
    });
    const result = await getDrivers();
    assert.deepEqual(result.drivers, []);
  });
});

describe('approve-driver use-case', () => {
  it('başvuru bulunamazsa 404 fırlatır', async () => {
    const approve = createApproveDriverUseCase({
      driverRepository: makeFakeDriverRepo({ async findApplicationById() { return null; } }),
      adminActionRepository: makeFakeAdminActionRepo(),
    });
    await assert.rejects(
      () => approve({ appId: 'app-999', adminId: 'a-001' }),
      (err) => { assert.equal(err.statusCode, 404); return true; },
    );
  });

  it('başvuru onaylanır ve admin action loglanır', async () => {
    let logged = null;
    const app = { appId: 'app-001', userId: 'u-001', status: 'training_complete' };
    const approve = createApproveDriverUseCase({
      driverRepository: makeFakeDriverRepo({
        async findApplicationById() { return app; },
        async approveApplication(appId, adminId) { return { ...app, status: 'approved', adminId }; },
      }),
      adminActionRepository: makeFakeAdminActionRepo({ async log(data) { logged = data; } }),
    });
    const result = await approve({ appId: 'app-001', adminId: 'a-001' });
    assert.equal(result.status, 'approved');
    assert.equal(logged.actionType, 'approve_driver');
    assert.equal(logged.adminId, 'a-001');
  });
});

describe('reject-driver use-case', () => {
  it('başvuru bulunamazsa 404 fırlatır', async () => {
    const reject = createRejectDriverUseCase({
      driverRepository: makeFakeDriverRepo({ async findApplicationById() { return null; } }),
      adminActionRepository: makeFakeAdminActionRepo(),
    });
    await assert.rejects(
      () => reject({ appId: 'app-999', adminId: 'a-001', notes: 'Eksik belge' }),
      (err) => { assert.equal(err.statusCode, 404); return true; },
    );
  });

  it('başvuru reddedilir ve admin action loglanır', async () => {
    let logged = null;
    const app = { appId: 'app-001', userId: 'u-001', status: 'training_complete' };
    const reject = createRejectDriverUseCase({
      driverRepository: makeFakeDriverRepo({
        async findApplicationById() { return app; },
        async rejectApplication(appId, adminId) { return { ...app, status: 'rejected', adminId }; },
      }),
      adminActionRepository: makeFakeAdminActionRepo({ async log(data) { logged = data; } }),
    });
    const result = await reject({ appId: 'app-001', adminId: 'a-001', notes: 'Eksik belge' });
    assert.equal(result.status, 'rejected');
    assert.equal(logged.actionType, 'reject_driver');
  });
});

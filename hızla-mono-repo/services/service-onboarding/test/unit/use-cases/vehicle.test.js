import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeApplicationRepo } from '../../helpers/index.js';
import createSelectVehicleUseCase from '#core/application/use-cases/onboarding/select-vehicle.use-case.js';

const pendingApp = { appId: 'app-001', userId: 'u-001', status: 'pending', vehicleType: null };

describe('select-vehicle use-case', () => {
  it('geçersiz araç tipi 400 fırlatır', async () => {
    const selectVehicle = createSelectVehicleUseCase({
      applicationRepository: makeFakeApplicationRepo({ async findByUserId() { return pendingApp; } }),
    });
    await assert.rejects(
      () => selectVehicle({ userId: 'u-001', vehicleType: 'tank' }),
      (err) => { assert.equal(err.statusCode, 400); return true; },
    );
  });

  it('başvuru yoksa otomatik oluşturulur ve araç seçilir', async () => {
    let created = null;
    const selectVehicle = createSelectVehicleUseCase({
      applicationRepository: makeFakeApplicationRepo({
        async findByUserId() { return null; },
        async create(data) { created = data; return { appId: 'app-new', ...data }; },
        async updateVehicle(appId, vt) { return { appId, vehicleType: vt, status: 'pending' }; },
      }),
    });
    const result = await selectVehicle({ userId: 'u-001', vehicleType: 'bicycle' });
    assert.ok(created);
    assert.equal(result.vehicleType, 'bicycle');
  });

  it('mevcut başvuruda araç güncellenir', async () => {
    let updatedVehicle = null;
    const selectVehicle = createSelectVehicleUseCase({
      applicationRepository: makeFakeApplicationRepo({
        async findByUserId() { return { ...pendingApp }; },
        async updateVehicle(appId, vt) { updatedVehicle = vt; return { ...pendingApp, vehicleType: vt }; },
      }),
    });
    await selectVehicle({ userId: 'u-001', vehicleType: 'motorcycle' });
    assert.equal(updatedVehicle, 'motorcycle');
  });
});

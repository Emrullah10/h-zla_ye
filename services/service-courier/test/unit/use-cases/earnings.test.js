import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeCourierRepo, makeFakeEarningsRepo } from '../../helpers/index.js';
import createGetEarningsUseCase from '#core/application/use-cases/wallet/get-earnings.use-case.js';

const testCourier = { courierId: 'c-001', userId: 'u-001' };

describe('get-earnings use-case', () => {
  it('kurye bulunamazsa 404 fırlatır', async () => {
    const getEarnings = createGetEarningsUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return null; } }),
      earningsRepository: makeFakeEarningsRepo(),
    });
    await assert.rejects(
      () => getEarnings({ userId: 'u-999', period: 'weekly' }),
      (err) => { assert.equal(err.statusCode, 404); return true; },
    );
  });

  it('geçersiz period 400 fırlatır', async () => {
    const getEarnings = createGetEarningsUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      earningsRepository: makeFakeEarningsRepo(),
    });
    await assert.rejects(
      () => getEarnings({ userId: 'u-001', period: 'yearly' }),
      (err) => { assert.equal(err.statusCode, 400); return true; },
    );
  });

  it('weekly earnings döner', async () => {
    const earningsData = {
      total: 450, bars: [{ label: 'Pzt', amount: 60 }], orderCount: 12, avgOrderFee: 37.5, onlineHours: 8,
    };
    const getEarnings = createGetEarningsUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      earningsRepository: makeFakeEarningsRepo({ async getEarnings() { return earningsData; } }),
    });
    const result = await getEarnings({ userId: 'u-001', period: 'weekly' });
    assert.equal(result.total, 450);
    assert.ok(Array.isArray(result.bars));
  });

  it('monthly earnings döner', async () => {
    const earningsData = {
      total: 1800, bars: [{ label: 'Hf1', amount: 450 }], orderCount: 48, avgOrderFee: 37.5, onlineHours: 32,
    };
    const getEarnings = createGetEarningsUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      earningsRepository: makeFakeEarningsRepo({ async getEarnings() { return earningsData; } }),
    });
    const result = await getEarnings({ userId: 'u-001', period: 'monthly' });
    assert.equal(result.total, 1800);
  });
});

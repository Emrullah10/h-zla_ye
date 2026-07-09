import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeCourierRepo, makeFakeOrderRepo } from '../../helpers/index.js';
import createVerifyPackageUseCase from '#core/application/use-cases/order/verify-package.use-case.js';

const testCourier = { courierId: 'c-001', userId: 'u-001' };
const acceptedOrder = { orderId: 'o-001', courierId: 'c-001', status: 'accepted', qrCode: 'QR-VALID' };

describe('verify-package use-case', () => {
  it('sipariş bulunamazsa 404 fırlatır', async () => {
    const verify = createVerifyPackageUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      orderRepository: makeFakeOrderRepo({ async findById() { return null; } }),
    });
    await assert.rejects(
      () => verify({ userId: 'u-001', orderId: 'o-999', qrCode: 'QR-VALID' }),
      (err) => { assert.equal(err.statusCode, 404); return true; },
    );
  });

  it('QR kodu eşleşmezse 400 fırlatır', async () => {
    const verify = createVerifyPackageUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      orderRepository: makeFakeOrderRepo({ async findById() { return { ...acceptedOrder }; } }),
    });
    await assert.rejects(
      () => verify({ userId: 'u-001', orderId: 'o-001', qrCode: 'QR-WRONG' }),
      (err) => { assert.equal(err.statusCode, 400); return true; },
    );
  });

  it('QR eşleşirse status picked_up olur', async () => {
    let updatedStatus = null;
    const verify = createVerifyPackageUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      orderRepository: makeFakeOrderRepo({
        async findById() { return { ...acceptedOrder }; },
        async updateStatus(id, status) { updatedStatus = status; return { ...acceptedOrder, status }; },
      }),
    });
    await verify({ userId: 'u-001', orderId: 'o-001', qrCode: 'QR-VALID' });
    assert.equal(updatedStatus, 'picked_up');
  });
});

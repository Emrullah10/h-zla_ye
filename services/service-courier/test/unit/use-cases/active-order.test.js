import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeCourierRepo, makeFakeOrderRepo } from '../../helpers/index.js';
import createGetActiveOrderUseCase from '#core/application/use-cases/order/get-active-order.use-case.js';

const testCourier = { courierId: 'c-001', userId: 'u-001', name: 'Test Kurye', status: 'online' };

describe('get-active-order use-case', () => {
  it('kullanıcı kurye değilse hata fırlatır', async () => {
    const getActiveOrder = createGetActiveOrderUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return null; } }),
      orderRepository: makeFakeOrderRepo(),
    });

    await assert.rejects(
      () => getActiveOrder({ userId: 'u-999' }),
      (err) => { assert.equal(err.statusCode, 404); return true; },
    );
  });

  it('aktif sipariş yoksa null döner', async () => {
    const getActiveOrder = createGetActiveOrderUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      orderRepository: makeFakeOrderRepo({ async findActiveByCourierId() { return null; } }),
    });

    const result = await getActiveOrder({ userId: 'u-001' });
    assert.equal(result, null);
  });

  it('aktif sipariş varsa döner', async () => {
    const activeOrder = {
      orderId: 'o-001', courierId: 'c-001', restaurantName: 'Burger', status: 'accepted',
      pickupAddr: 'A', deliveryAddr: 'B', amount: 80, fee: 10, distanceMeters: 1500, qrCode: 'QR1',
    };

    const getActiveOrder = createGetActiveOrderUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      orderRepository: makeFakeOrderRepo({ async findActiveByCourierId() { return activeOrder; } }),
    });

    const result = await getActiveOrder({ userId: 'u-001' });
    assert.equal(result.orderId, 'o-001');
    assert.equal(result.status, 'accepted');
  });
});

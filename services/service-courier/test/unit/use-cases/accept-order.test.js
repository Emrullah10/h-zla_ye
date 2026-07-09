import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeCourierRepo, makeFakeOrderRepo } from '../../helpers/index.js';
import createAcceptOrderUseCase from '#core/application/use-cases/order/accept-order.use-case.js';

const testCourier = { courierId: 'c-001', userId: 'u-001' };
const pendingOrder = { orderId: 'o-001', courierId: null, status: 'pending' };

describe('accept-order use-case', () => {
  it('kurye bulunamazsa 404 fırlatır', async () => {
    const acceptOrder = createAcceptOrderUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return null; } }),
      orderRepository: makeFakeOrderRepo(),
    });

    await assert.rejects(
      () => acceptOrder({ userId: 'u-999', orderId: 'o-001' }),
      (err) => { assert.equal(err.statusCode, 404); return true; },
    );
  });

  it('sipariş bulunamazsa 404 fırlatır', async () => {
    const acceptOrder = createAcceptOrderUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      orderRepository: makeFakeOrderRepo({ async findById() { return null; } }),
    });

    await assert.rejects(
      () => acceptOrder({ userId: 'u-001', orderId: 'o-999' }),
      (err) => { assert.equal(err.statusCode, 404); return true; },
    );
  });

  it('sipariş pending değilse 400 fırlatır', async () => {
    const acceptOrder = createAcceptOrderUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      orderRepository: makeFakeOrderRepo({ async findById() { return { ...pendingOrder, status: 'accepted' }; } }),
    });

    await assert.rejects(
      () => acceptOrder({ userId: 'u-001', orderId: 'o-001' }),
      (err) => { assert.equal(err.statusCode, 400); return true; },
    );
  });

  it('başarılı kabul — updateStatus çağrılır ve sipariş döner', async () => {
    let updatedId = null, updatedStatus = null;
    const acceptOrder = createAcceptOrderUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      orderRepository: makeFakeOrderRepo({
        async findById() { return { ...pendingOrder }; },
        async updateStatus(orderId, status) {
          updatedId = orderId; updatedStatus = status;
          return { ...pendingOrder, status };
        },
      }),
    });

    const result = await acceptOrder({ userId: 'u-001', orderId: 'o-001' });
    assert.equal(updatedId, 'o-001');
    assert.equal(updatedStatus, 'accepted');
    assert.equal(result.status, 'accepted');
  });
});

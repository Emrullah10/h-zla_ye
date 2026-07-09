import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeCourierRepo, makeFakeOrderRepo } from '../../helpers/index.js';
import createRejectOrderUseCase from '#core/application/use-cases/order/reject-order.use-case.js';

const testCourier = { courierId: 'c-001', userId: 'u-001' };
const acceptedOrder = { orderId: 'o-001', courierId: 'c-001', status: 'accepted' };

describe('reject-order use-case', () => {
  it('kurye bulunamazsa 404 fırlatır', async () => {
    const rejectOrder = createRejectOrderUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return null; } }),
      orderRepository: makeFakeOrderRepo(),
    });
    await assert.rejects(
      () => rejectOrder({ userId: 'u-999', orderId: 'o-001' }),
      (err) => { assert.equal(err.statusCode, 404); return true; },
    );
  });

  it('sipariş accepted değilse 400 fırlatır', async () => {
    const rejectOrder = createRejectOrderUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      orderRepository: makeFakeOrderRepo({ async findById() { return { ...acceptedOrder, status: 'pending' }; } }),
    });
    await assert.rejects(
      () => rejectOrder({ userId: 'u-001', orderId: 'o-001' }),
      (err) => { assert.equal(err.statusCode, 400); return true; },
    );
  });

  it('başarılı red — status rejected olur', async () => {
    let updatedStatus = null;
    const rejectOrder = createRejectOrderUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      orderRepository: makeFakeOrderRepo({
        async findById() { return { ...acceptedOrder }; },
        async updateStatus(id, status) { updatedStatus = status; return { ...acceptedOrder, status }; },
      }),
    });
    await rejectOrder({ userId: 'u-001', orderId: 'o-001' });
    assert.equal(updatedStatus, 'rejected');
  });
});

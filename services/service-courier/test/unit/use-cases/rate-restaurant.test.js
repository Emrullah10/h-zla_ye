import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeCourierRepo, makeFakeOrderRepo } from '../../helpers/index.js';
import createRateRestaurantUseCase from '#core/application/use-cases/order/rate-restaurant.use-case.js';

const testCourier = { courierId: 'c-001', userId: 'u-001' };
const deliveredOrder = { orderId: 'o-001', courierId: 'c-001', status: 'delivered' };

describe('rate-restaurant use-case', () => {
  it('rating 1-5 dışındaysa 400 fırlatır', async () => {
    const rate = createRateRestaurantUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      orderRepository: makeFakeOrderRepo({ async findById() { return { ...deliveredOrder }; } }),
      ratingRepository: { async create() {} },
    });
    await assert.rejects(
      () => rate({ userId: 'u-001', orderId: 'o-001', rating: 6 }),
      (err) => { assert.equal(err.statusCode, 400); return true; },
    );
  });

  it('sipariş delivered değilse 400 fırlatır', async () => {
    const rate = createRateRestaurantUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      orderRepository: makeFakeOrderRepo({ async findById() { return { ...deliveredOrder, status: 'accepted' }; } }),
      ratingRepository: { async create() {} },
    });
    await assert.rejects(
      () => rate({ userId: 'u-001', orderId: 'o-001', rating: 4 }),
      (err) => { assert.equal(err.statusCode, 400); return true; },
    );
  });

  it('başarılı rating — ratingRepository.create çağrılır', async () => {
    let created = null;
    const rate = createRateRestaurantUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      orderRepository: makeFakeOrderRepo({ async findById() { return { ...deliveredOrder }; } }),
      ratingRepository: { async create(data) { created = data; return data; } },
    });
    await rate({ userId: 'u-001', orderId: 'o-001', rating: 5, comment: 'İyi' });
    assert.equal(created.restaurantRating, 5);
    assert.equal(created.orderId, 'o-001');
    assert.equal(created.courierId, 'c-001');
  });
});

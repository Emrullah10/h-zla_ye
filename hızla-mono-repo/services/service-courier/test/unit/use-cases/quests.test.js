import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeCourierRepo, makeFakeQuestRepo } from '../../helpers/index.js';
import createGetQuestsUseCase from '#core/application/use-cases/quest/get-quests.use-case.js';

const testCourier = { courierId: 'c-001', userId: 'u-001' };

describe('get-quests use-case', () => {
  it('kurye bulunamazsa 404 fırlatır', async () => {
    const getQuests = createGetQuestsUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return null; } }),
      questRepository: makeFakeQuestRepo(),
    });
    await assert.rejects(
      () => getQuests({ userId: 'u-999' }),
      (err) => { assert.equal(err.statusCode, 404); return true; },
    );
  });

  it('quest listesi döner', async () => {
    const quests = [
      { questId: 'q-001', title: 'İlk 5', description: '5 sipariş', reward: 50, rarity: 'common', progress: 2, targetCount: 5 },
    ];
    const getQuests = createGetQuestsUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      questRepository: makeFakeQuestRepo({ async findByCourierId() { return quests; } }),
    });
    const result = await getQuests({ userId: 'u-001' });
    assert.equal(result.quests.length, 1);
    assert.equal(result.quests[0].questId, 'q-001');
  });

  it('quest yoksa boş liste döner', async () => {
    const getQuests = createGetQuestsUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      questRepository: makeFakeQuestRepo({ async findByCourierId() { return []; } }),
    });
    const result = await getQuests({ userId: 'u-001' });
    assert.deepEqual(result.quests, []);
  });
});

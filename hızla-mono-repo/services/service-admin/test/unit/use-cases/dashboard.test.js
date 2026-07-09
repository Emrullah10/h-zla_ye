import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeDashboardRepo } from '../../helpers/index.js';
import createGetDashboardUseCase from '#core/application/use-cases/admin/get-dashboard.use-case.js';

describe('get-dashboard use-case', () => {
  it('dashboard istatistiklerini döner', async () => {
    const stats = { activeCouriers: 5, todayOrders: 42, dailyRevenue: 1250.75, pendingApprovals: 3 };
    const getDashboard = createGetDashboardUseCase({
      dashboardRepository: makeFakeDashboardRepo({ async getStats() { return stats; } }),
    });
    const result = await getDashboard();
    assert.equal(result.activeCouriers, 5);
    assert.equal(result.todayOrders, 42);
    assert.equal(result.dailyRevenue, 1250.75);
    assert.equal(result.pendingApprovals, 3);
  });
});

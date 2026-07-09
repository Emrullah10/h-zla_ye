import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeCourierRepo, makeFakeWalletRepo } from '../../helpers/index.js';
import createGetWalletUseCase from '#core/application/use-cases/wallet/get-wallet.use-case.js';

const testCourier = { courierId: 'c-001', userId: 'u-001' };

describe('get-wallet use-case', () => {
  it('kurye bulunamazsa 404 fırlatır', async () => {
    const getWallet = createGetWalletUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return null; } }),
      walletRepository: makeFakeWalletRepo(),
    });
    await assert.rejects(
      () => getWallet({ userId: 'u-999' }),
      (err) => { assert.equal(err.statusCode, 404); return true; },
    );
  });

  it('cüzdan bilgisi ve işlemler döner', async () => {
    const wallet = { walletId: 'w-001', courierId: 'c-001', balance: 250, pending: 75 };
    const transactions = [
      { txId: 'tx-001', amount: 50, type: 'credit', description: 'Teslimat', createdAt: new Date() },
    ];

    const getWallet = createGetWalletUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      walletRepository: makeFakeWalletRepo({
        async findByCourierId() { return wallet; },
        async findTransactions() { return transactions; },
      }),
    });

    const result = await getWallet({ userId: 'u-001' });
    assert.equal(result.balance, 250);
    assert.equal(result.pending, 75);
    assert.equal(result.transactions.length, 1);
    assert.equal(result.transactions[0].txId, 'tx-001');
  });
});

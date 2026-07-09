import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { makeFakeCourierRepo, makeFakeSupportRepo } from '../../helpers/index.js';
import createCreateSupportTicketUseCase from '#core/application/use-cases/support/create-support-ticket.use-case.js';

const testCourier = { courierId: 'c-001', userId: 'u-001' };

describe('create-support-ticket use-case', () => {
  it('kurye bulunamazsa 404 fırlatır', async () => {
    const createTicket = createCreateSupportTicketUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return null; } }),
      supportRepository: makeFakeSupportRepo(),
    });
    await assert.rejects(
      () => createTicket({ userId: 'u-999', category: 'payment', subject: 'Test', message: 'Msg' }),
      (err) => { assert.equal(err.statusCode, 404); return true; },
    );
  });

  it('category eksikse 400 fırlatır', async () => {
    const createTicket = createCreateSupportTicketUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      supportRepository: makeFakeSupportRepo(),
    });
    await assert.rejects(
      () => createTicket({ userId: 'u-001', category: '', subject: 'Test', message: 'Msg' }),
      (err) => { assert.equal(err.statusCode, 400); return true; },
    );
  });

  it('message eksikse 400 fırlatır', async () => {
    const createTicket = createCreateSupportTicketUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      supportRepository: makeFakeSupportRepo(),
    });
    await assert.rejects(
      () => createTicket({ userId: 'u-001', category: 'payment', subject: 'Test', message: '' }),
      (err) => { assert.equal(err.statusCode, 400); return true; },
    );
  });

  it('başarılı ticket oluşturma — ticketId döner', async () => {
    const createTicket = createCreateSupportTicketUseCase({
      courierRepository: makeFakeCourierRepo({ async findByUserId() { return testCourier; } }),
      supportRepository: makeFakeSupportRepo({ async create(data) { return { ticketId: 't-001', ...data }; } }),
    });
    const result = await createTicket({ userId: 'u-001', category: 'order', subject: 'Sorun', message: 'Detay' });
    assert.ok(result.ticketId);
    assert.equal(result.courierId, 'c-001');
  });
});

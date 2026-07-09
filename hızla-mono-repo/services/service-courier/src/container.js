import datasources from '@hizla/datasource/index.js';
import {
  CourierRepositoryImpl,
  OrderRepositoryImpl,
  RatingRepositoryImpl,
  WalletRepositoryImpl,
  EarningsRepositoryImpl,
  QuestRepositoryImpl,
  SupportRepositoryImpl,
} from '#core/infrastructure/persistence/repositories/courier.repository-impl.js';
import createGetActiveOrderUseCase from '#core/application/use-cases/order/get-active-order.use-case.js';
import createAcceptOrderUseCase from '#core/application/use-cases/order/accept-order.use-case.js';
import createRejectOrderUseCase from '#core/application/use-cases/order/reject-order.use-case.js';
import createVerifyPackageUseCase from '#core/application/use-cases/order/verify-package.use-case.js';
import createRateRestaurantUseCase from '#core/application/use-cases/order/rate-restaurant.use-case.js';
import createGetWalletUseCase from '#core/application/use-cases/wallet/get-wallet.use-case.js';
import createGetEarningsUseCase from '#core/application/use-cases/wallet/get-earnings.use-case.js';
import createGetQuestsUseCase from '#core/application/use-cases/quest/get-quests.use-case.js';
import createCreateSupportTicketUseCase from '#core/application/use-cases/support/create-support-ticket.use-case.js';

export const buildContainer = () => {
  const db = datasources.coreAppDb;

  const courierRepository = new CourierRepositoryImpl(db);
  const orderRepository = new OrderRepositoryImpl(db);
  const ratingRepository = new RatingRepositoryImpl(db);
  const walletRepository = new WalletRepositoryImpl(db);
  const earningsRepository = new EarningsRepositoryImpl(db);
  const questRepository = new QuestRepositoryImpl(db);
  const supportRepository = new SupportRepositoryImpl(db);

  return {
    getActiveOrder: createGetActiveOrderUseCase({ courierRepository, orderRepository }),
    acceptOrder: createAcceptOrderUseCase({ courierRepository, orderRepository }),
    rejectOrder: createRejectOrderUseCase({ courierRepository, orderRepository }),
    verifyPackage: createVerifyPackageUseCase({ courierRepository, orderRepository }),
    rateRestaurant: createRateRestaurantUseCase({ courierRepository, orderRepository, ratingRepository }),
    getWallet: createGetWalletUseCase({ courierRepository, walletRepository }),
    getEarnings: createGetEarningsUseCase({ courierRepository, earningsRepository }),
    getQuests: createGetQuestsUseCase({ courierRepository, questRepository }),
    createSupportTicket: createCreateSupportTicketUseCase({ courierRepository, supportRepository }),
  };
};

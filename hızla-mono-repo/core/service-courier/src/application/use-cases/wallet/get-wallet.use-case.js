import { CourierErrors } from '../../../domain/courier/courier.errors.js';

export default function createGetWalletUseCase({ courierRepository, walletRepository }) {
  return async function getWallet({ userId }) {
    const courier = await courierRepository.findByUserId(userId);
    if (!courier) throw CourierErrors.NOT_FOUND();

    const wallet = await walletRepository.findByCourierId(courier.courierId);
    const transactions = await walletRepository.findTransactions(courier.courierId);

    return { ...wallet, transactions };
  };
}

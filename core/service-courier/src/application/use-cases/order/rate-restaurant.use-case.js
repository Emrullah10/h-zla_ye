import { CourierErrors } from '../../../domain/courier/courier.errors.js';

export default function createRateRestaurantUseCase({ courierRepository, orderRepository, ratingRepository }) {
  return async function rateRestaurant({ userId, orderId, rating, comment }) {
    if (rating < 1 || rating > 5) throw CourierErrors.INVALID_RATING();

    const courier = await courierRepository.findByUserId(userId);
    if (!courier) throw CourierErrors.NOT_FOUND();

    const order = await orderRepository.findById(orderId);
    if (!order) throw CourierErrors.ORDER_NOT_FOUND();
    if (order.status !== 'delivered') throw CourierErrors.ORDER_NOT_DELIVERED();

    return ratingRepository.create({
      orderId,
      courierId: courier.courierId,
      restaurantRating: rating,
      comment: comment ?? null,
    });
  };
}

import '../../../shared/utils/json_parse.dart';

/// Platform entegrasyonu — sipariş kartındaki rozet rengi için.
enum OrderPlatform { yemeksepeti, getir, trendyol, unknown }

double? _toNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

OrderPlatform _platformFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'yemeksepeti':
      return OrderPlatform.yemeksepeti;
    case 'getir':
      return OrderPlatform.getir;
    case 'trendyol':
      return OrderPlatform.trendyol;
    default:
      return OrderPlatform.unknown;
  }
}

/// GET /courier/order/active yanıtı — order.repository.js / findById,
/// findActiveByCourierId ile birebir (web api/courier.jsx + IncomingOrderOverlay
/// alan adlarıyla doğrulandı: restaurant, customerAddress, fee, distanceMeters).
/// Backend'de Redis/Docker yerelde kapalı olduğundan tüm alanlar nullable/esnek
/// tutulur — null veya boş obje gelirse "aktif sipariş yok" sayılır.
class ActiveOrder {
  const ActiveOrder({
    required this.id,
    required this.restaurantName,
    required this.orderNumber,
    required this.customerAddress,
    required this.distanceMeters,
    required this.etaMinutes,
    required this.earnings,
    required this.platform,
    required this.status,
    this.pickupLat,
    this.pickupLng,
    this.deliveryLat,
    this.deliveryLng,
  });

  final String id;
  final String restaurantName;
  final String? orderNumber;
  final String customerAddress;
  final double distanceMeters;
  final int etaMinutes;
  final double earnings;
  final OrderPlatform platform;
  final String status;
  final double? pickupLat;
  final double? pickupLng;
  final double? deliveryLat;
  final double? deliveryLng;

  double get distanceKm => distanceMeters / 1000;

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isAccepted => status.toLowerCase() == 'accepted';
  bool get isPickedUp => status.toLowerCase() == 'picked_up';
  bool get isDelivered => status.toLowerCase() == 'delivered';

  /// response.data null, boş obje veya id yoksa "aktif sipariş yok" sayılır.
  static ActiveOrder? fromJsonOrNull(dynamic raw) {
    if (raw == null) return null;
    if (raw is! Map<String, dynamic>) return null;
    if (raw.isEmpty) return null;
    final id = raw['id']?.toString() ?? raw['orderId']?.toString();
    if (id == null) return null;

    return ActiveOrder(
      id: id,
      restaurantName: raw['restaurant']?.toString() ??
          raw['restaurantName']?.toString() ??
          'Restoran',
      orderNumber: raw['orderNumber']?.toString() ?? raw['number']?.toString(),
      customerAddress: raw['customerAddress']?.toString() ??
          raw['address']?.toString() ??
          '',
      distanceMeters: toDoubleSafe(raw['distanceMeters'] ?? raw['distance']),
      etaMinutes: toIntSafe(raw['etaMinutes'] ?? raw['eta']),
      earnings: toDoubleSafe(raw['fee'] ?? raw['earnings']),
      platform: _platformFromString(
          raw['platform']?.toString() ?? raw['integration']?.toString()),
      status: raw['status']?.toString() ?? 'pending',
      pickupLat: _toNullableDouble(raw['pickupLat'] ?? raw['pickup_lat']),
      pickupLng: _toNullableDouble(raw['pickupLng'] ?? raw['pickup_lng']),
      deliveryLat: _toNullableDouble(raw['deliveryLat'] ?? raw['delivery_lat']),
      deliveryLng: _toNullableDouble(raw['deliveryLng'] ?? raw['delivery_lng']),
    );
  }
}

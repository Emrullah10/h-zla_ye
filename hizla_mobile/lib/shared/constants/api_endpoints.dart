/// Gateway path'leri — services/service-gateway/src/route.js ve
/// services/service-*/routes/rest-routes.js ile birebir eşleşir.
class ApiEndpoints {
  ApiEndpoints._();

  // Auth (gateway)
  static const login = '/auth/login';
  static const me = '/gateway/me';
  static const refresh = '/gateway/refresh';
  static const logout = '/gateway/logout';

  // Onboarding
  static const onboardingStatus = '/onboarding/status';
  static const onboardingVehicle = '/onboarding/vehicle';
  static const onboardingDocument = '/onboarding/document';
  static const onboardingTrainingComplete = '/onboarding/training/complete';

  // Courier
  static const activeOrder = '/courier/order/active';
  static String acceptOrder(String id) => '/courier/order/$id/accept';
  static String rejectOrder(String id) => '/courier/order/$id/reject';
  static String verifyOrder(String id) => '/courier/order/$id/verify';
  static String rateOrder(String id) => '/courier/order/$id/rate';
  static const wallet = '/courier/wallet';
  static const earnings = '/courier/earnings';
  static const quests = '/courier/quests';
  static const support = '/courier/support';
}

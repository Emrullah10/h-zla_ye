import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/splash_screen.dart';
import '../../features/auth/viewmodel/auth_state.dart';
import '../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../features/dashboard/view/dashboard_screen.dart';
import '../../features/earnings/view/earnings_screen.dart';
import '../../features/onboarding/model/onboarding_status.dart';
import '../../features/onboarding/view/document_upload_screen.dart';
import '../../features/onboarding/view/personal_info_screen.dart';
import '../../features/onboarding/view/pending_approval_screen.dart';
import '../../features/onboarding/view/training_screen.dart';
import '../../features/onboarding/view/vehicle_select_screen.dart';
import '../../features/onboarding/viewmodel/onboarding_viewmodel.dart';
import '../../features/orders/view/active_mission_screen.dart';
import '../../features/orders/view/emoji_rating_screen.dart';
import '../../features/orders/view/qr_verify_screen.dart';
import '../../features/profile/view/profile_screen.dart';
import '../../features/quests/view/quests_screen.dart';
import '../../features/slots/view/slot_marketplace_screen.dart';
import '../../features/support/view/support_hub_screen.dart';
import '../../features/wallet/view/wallet_screen.dart';
import 'route_paths.dart';

/// [ChangeNotifier] köprüsü: Riverpod AsyncNotifier değişimlerini go_router'ın
/// `refreshListenable`'ına bağlar, böylece auth state değişince redirect
/// otomatik yeniden değerlendirilir.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authViewModelProvider, (previous, next) => notifyListeners());
    ref.listen(onboardingViewModelProvider, (previous, next) => notifyListeners());
  }
}

const _onboardingStepPaths = {
  OnboardingStep.vehicle: RoutePaths.onboardingVehicle,
  OnboardingStep.documents: RoutePaths.onboardingDocuments,
  OnboardingStep.personalInfo: RoutePaths.onboardingPersonal,
  OnboardingStep.training: RoutePaths.onboardingTraining,
  OnboardingStep.pendingApproval: RoutePaths.onboardingPending,
};

const _onboardingPaths = {
  RoutePaths.onboardingVehicle,
  RoutePaths.onboardingDocuments,
  RoutePaths.onboardingPersonal,
  RoutePaths.onboardingTraining,
  RoutePaths.onboardingPending,
};

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authViewModelProvider);
      final location = state.matchedLocation;

      return authState.when(
        loading: () => location == RoutePaths.splash ? null : RoutePaths.splash,
        error: (error, stack) => location == RoutePaths.login ? null : RoutePaths.login,
        data: (session) {
          switch (session) {
            case AuthUnknown():
              return location == RoutePaths.splash ? null : RoutePaths.splash;
            case AuthUnauthenticated():
              return location == RoutePaths.login ? null : RoutePaths.login;
            case AuthOnboarding():
              return _redirectForOnboarding(ref, location);
            case AuthActive():
              final isAuthOrOnboarding =
                  location == RoutePaths.login || _onboardingPaths.contains(location) || location == RoutePaths.splash;
              return isAuthOrOnboarding ? RoutePaths.dashboard : null;
          }
        },
      );
    },
    routes: [
      GoRoute(path: RoutePaths.splash, builder: (c, s) => const SplashScreen()),
      GoRoute(path: RoutePaths.login, builder: (c, s) => const LoginScreen()),
      GoRoute(
          path: RoutePaths.onboardingVehicle,
          builder: (c, s) => const VehicleSelectScreen()),
      GoRoute(
          path: RoutePaths.onboardingDocuments,
          builder: (c, s) => const DocumentUploadScreen()),
      GoRoute(
          path: RoutePaths.onboardingPersonal,
          builder: (c, s) => const PersonalInfoScreen()),
      GoRoute(
          path: RoutePaths.onboardingTraining,
          builder: (c, s) => const TrainingScreen()),
      GoRoute(
          path: RoutePaths.onboardingPending,
          builder: (c, s) => const PendingApprovalScreen()),
      GoRoute(path: RoutePaths.dashboard, builder: (c, s) => const DashboardScreen()),
      GoRoute(
          path: RoutePaths.activeMission,
          builder: (c, s) => ActiveMissionScreen(orderId: s.extra as String?)),
      GoRoute(
          path: RoutePaths.qrVerify,
          builder: (c, s) => QrVerifyScreen(orderId: s.extra as String?)),
      GoRoute(
          path: RoutePaths.emojiRating,
          builder: (c, s) => EmojiRatingScreen(orderId: s.extra as String?)),
      GoRoute(path: RoutePaths.earnings, builder: (c, s) => const EarningsScreen()),
      GoRoute(path: RoutePaths.wallet, builder: (c, s) => const WalletScreen()),
      GoRoute(
          path: RoutePaths.slots, builder: (c, s) => const SlotMarketplaceScreen()),
      GoRoute(path: RoutePaths.quests, builder: (c, s) => const QuestsScreen()),
      GoRoute(path: RoutePaths.support, builder: (c, s) => const SupportHubScreen()),
      GoRoute(path: RoutePaths.profile, builder: (c, s) => const ProfileScreen()),
    ],
  );
});

String? _redirectForOnboarding(Ref ref, String location) {
  final onboardingState = ref.read(onboardingViewModelProvider);
  final step = onboardingState.valueOrNull?.step;
  if (step == null) {
    // Onboarding verisi henüz yüklenmedi; splash'te bekle.
    return location == RoutePaths.splash ? null : RoutePaths.splash;
  }
  final target = _onboardingStepPaths[step];
  if (target == null) return null; // approved → AuthActive zaten devreye girer
  return location == target ? null : target;
}

import '../model/auth_session.dart';
import '../model/driver_profile.dart';

sealed class AuthState {
  const AuthState();
}

/// Uygulama henüz kontrol etmedi (splash).
class AuthUnknown extends AuthState {
  const AuthUnknown();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Giriş yapılmış ama onboarding tamamlanmamış.
class AuthOnboarding extends AuthState {
  const AuthOnboarding(this.session);
  final AuthSession session;
}

/// Giriş yapılmış ve onboarding onaylanmış — ana uygulamaya erişebilir.
class AuthActive extends AuthState {
  const AuthActive(this.session, this.driver);
  final AuthSession session;
  final DriverProfile? driver;
}

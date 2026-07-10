import 'driver_profile.dart';

/// Login veya /me yanıtının ortak çekirdeği.
class AuthSession {
  const AuthSession({
    required this.userId,
    required this.role,
    required this.userPermissionList,
    required this.onboardingStatus,
    this.driver,
  });

  final String userId;
  final String role;
  final List<String> userPermissionList;

  /// Backend'deki onboarding.status alanı: 'approved' | 'pending' | null vb.
  final String? onboardingStatus;

  /// Yalnızca login yanıtında gelir; /me'de null olabilir (secure storage'dan doldurulur).
  final DriverProfile? driver;

  bool get isApproved => onboardingStatus?.toLowerCase() == 'approved';

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
        userId: json['userId']?.toString() ?? '',
        role: json['role']?.toString() ?? '',
        userPermissionList: (json['userPermissionList'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        onboardingStatus: json['onboardingStatus']?.toString(),
        driver: json['driver'] is Map<String, dynamic>
            ? DriverProfile.fromJson(json['driver'] as Map<String, dynamic>)
            : null,
      );

  AuthSession copyWith({DriverProfile? driver, String? onboardingStatus}) =>
      AuthSession(
        userId: userId,
        role: role,
        userPermissionList: userPermissionList,
        onboardingStatus: onboardingStatus ?? this.onboardingStatus,
        driver: driver ?? this.driver,
      );
}

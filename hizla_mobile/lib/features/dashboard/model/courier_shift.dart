/// Kuryenin online/offline durumu — tamamen lokal (backend'de shift/session
/// endpoint'i yok), "MÜSAİT OL" slider'ıyla değiştirilir.
class CourierShift {
  const CourierShift({
    required this.isOnline,
    required this.activeSince,
    required this.dailySummaryEarnings,
  });

  final bool isOnline;
  final DateTime? activeSince;
  final double dailySummaryEarnings;

  Duration get activeDuration {
    if (activeSince == null) return Duration.zero;
    return DateTime.now().difference(activeSince!);
  }

  CourierShift copyWith({
    bool? isOnline,
    DateTime? activeSince,
    bool clearActiveSince = false,
    double? dailySummaryEarnings,
  }) {
    return CourierShift(
      isOnline: isOnline ?? this.isOnline,
      activeSince: clearActiveSince ? null : (activeSince ?? this.activeSince),
      dailySummaryEarnings: dailySummaryEarnings ?? this.dailySummaryEarnings,
    );
  }

  static const initial = CourierShift(
    isOnline: false,
    activeSince: null,
    dailySummaryEarnings: 0,
  );
}

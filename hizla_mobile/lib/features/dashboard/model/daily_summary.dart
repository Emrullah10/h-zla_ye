import '../../../shared/utils/json_parse.dart';

/// GET /courier/earnings?period=weekly yanıtından türetilen günlük özet.
/// get-earnings.use-case.js / earningsRepository.getEarnings şekli backend'de
/// serbest olduğundan (Redis/Docker yerelde kapalı, test edilemedi) esnek
/// parse edilir — bilinmeyen alan adları için 0 varsayılır.
class DailySummary {
  const DailySummary({required this.todayEarnings});

  final double todayEarnings;

  factory DailySummary.fromJson(Map<String, dynamic> json) => DailySummary(
        todayEarnings: toDoubleSafe(
            json['today'] ?? json['todayEarnings'] ?? json['totalEarnings']),
      );

  static const zero = DailySummary(todayEarnings: 0);
}

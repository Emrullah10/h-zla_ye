/// GET /courier/earnings?period=weekly|monthly yanıtı —
/// get-earnings.use-case.js + courier.repository-impl.js ile birebir.
class EarningsBar {
  const EarningsBar({required this.label, required this.amount});

  final String label;
  final double amount;

  factory EarningsBar.fromJson(Map<String, dynamic> json) => EarningsBar(
        label: json['label']?.toString() ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
      );
}

class Earnings {
  const Earnings({
    required this.total,
    required this.orderCount,
    required this.avgOrderFee,
    required this.onlineHours,
    required this.bars,
  });

  final double total;
  final int orderCount;
  final double avgOrderFee;
  final double onlineHours;
  final List<EarningsBar> bars;

  double get maxBarAmount =>
      bars.isEmpty ? 0 : bars.map((b) => b.amount).reduce((a, b) => a > b ? a : b);

  factory Earnings.fromJson(Map<String, dynamic> json) => Earnings(
        total: (json['total'] as num?)?.toDouble() ?? 0,
        orderCount: (json['orderCount'] as num?)?.toInt() ?? 0,
        avgOrderFee: (json['avgOrderFee'] as num?)?.toDouble() ?? 0,
        onlineHours: (json['onlineHours'] as num?)?.toDouble() ?? 0,
        bars: (json['bars'] as List<dynamic>?)
                ?.map((e) => EarningsBar.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

enum EarningsPeriod { weekly, monthly }

extension EarningsPeriodX on EarningsPeriod {
  String get apiValue => this == EarningsPeriod.weekly ? 'weekly' : 'monthly';
  String get label => this == EarningsPeriod.weekly ? 'Haftalık' : 'Aylık';
}

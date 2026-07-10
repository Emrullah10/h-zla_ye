/// Slot Marketplace — backend yok, MockSlotRepository ile statik veri.
/// Stitch slot-marketplace.html'deki 4 örnek slot kartını temsil eder.
enum SlotDemand { normal, high, peak }

enum SlotOwnership { mine, available }

class Slot {
  const Slot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.region,
    required this.demand,
    required this.ownership,
    required this.estimatedBase,
    this.multiplier,
  });

  final String id;
  final String startTime;
  final String endTime;
  final String region;
  final SlotDemand demand;
  final SlotOwnership ownership;
  final double estimatedBase;
  final double? multiplier;

  String get timeRange => '$startTime - $endTime';
}

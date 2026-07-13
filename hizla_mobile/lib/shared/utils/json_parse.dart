/// PostgreSQL numeric/decimal/bigint alanları pg driver'ında String olarak
/// döner (örn. "12.50", "2300"). Düz `as num` cast'i String değerde
/// `_TypeError` fırlatır — bu yüzden model parse'larında bu güvenli
/// yardımcılar kullanılmalı. Hem num hem String girdiyi kabul eder.
double toDoubleSafe(dynamic value, {double fallback = 0}) {
  if (value == null) return fallback;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? fallback;
}

int toIntSafe(dynamic value, {int fallback = 0}) {
  if (value == null) return fallback;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ??
      double.tryParse(value.toString())?.toInt() ??
      fallback;
}

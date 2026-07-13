import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage_provider.dart';

const _mapStyleKey = 'map_style';

/// Harita tile modu — uygulama temasından bağımsız.
enum MapStyle { light, dark, auto }

const _kDarkTileUrl =
    'https://cartodb-basemaps-a.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png';
const _kLightTileUrl =
    'https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png';

/// [style] + [now] saatine göre CARTO tile URL'ini çözer.
/// `auto`: 06:00–19:00 arası açık tile, gece koyu tile.
String resolvedMapTileUrl(MapStyle style, DateTime now) {
  switch (style) {
    case MapStyle.light:
      return _kLightTileUrl;
    case MapStyle.dark:
      return _kDarkTileUrl;
    case MapStyle.auto:
      final hour = now.hour;
      final isDaytime = hour >= 6 && hour < 19;
      return isDaytime ? _kLightTileUrl : _kDarkTileUrl;
  }
}

/// Kullanıcının harita modu tercihi — varsayılan [MapStyle.auto].
/// Değer `flutter_secure_storage`'da kalıcı tutulur.
class MapStyleNotifier extends Notifier<MapStyle> {
  @override
  MapStyle build() {
    _restore();
    return MapStyle.auto;
  }

  Future<void> _restore() async {
    final storage = ref.read(secureStorageProvider);
    final saved = await storage.read(key: _mapStyleKey);
    if (saved == null) return;
    state = MapStyle.values.firstWhere(
      (m) => m.name == saved,
      orElse: () => MapStyle.auto,
    );
  }

  Future<void> setMapStyle(MapStyle style) async {
    state = style;
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: _mapStyleKey, value: style.name);
  }
}

final mapStyleProvider = NotifierProvider<MapStyleNotifier, MapStyle>(
  MapStyleNotifier.new,
);

/// Aktif harita moduna göre güncel tile URL'i — dakikada bir saat kontrolü
/// gerekmez, widget rebuild olduğunda `DateTime.now()` taze okunur.
final mapTileUrlProvider = Provider<String>((ref) {
  final style = ref.watch(mapStyleProvider);
  return resolvedMapTileUrl(style, DateTime.now());
});

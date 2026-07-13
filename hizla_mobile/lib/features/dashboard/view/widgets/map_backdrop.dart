import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/location/location_provider.dart';
import '../../../../core/map/map_style_provider.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// Stitch pilot-dashboard.html'deki tam ekran harita arkaplanı.
/// Gerçek GPS konumu — izin verilmezse Beşiktaş fallback'e düşer.
class MapBackdrop extends ConsumerStatefulWidget {
  const MapBackdrop({super.key});

  @override
  ConsumerState<MapBackdrop> createState() => _MapBackdropState();
}

class _MapBackdropState extends ConsumerState<MapBackdrop> {
  final _mapController = MapController();
  bool _hasCentered = false;

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(courierLocationProvider);
    final location = locationAsync.valueOrNull ?? DeviceLocation.fallback;
    final tileUrl = ref.watch(mapTileUrlProvider);

    if (!_hasCentered || location.isReal) {
      _hasCentered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(location.point, _mapController.camera.zoom);
      });
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: location.point,
            initialZoom: 15.5,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: tileUrl,
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.hizlaye.mobile',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: location.point,
                  width: 20,
                  height: 20,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colors.neonCyan,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: context.colors.neonCyan.withValues(alpha: 0.6), blurRadius: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Üstten/alttan kararma — Stitch'teki gradient overlay.
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.colors.scaffold,
                  context.colors.scaffold.withValues(alpha: 0),
                  context.colors.scaffold.withValues(alpha: 0.85),
                ],
                stops: const [0.0, 0.35, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';

/// Stitch pilot-dashboard.html'deki tam ekran harita arkaplanı.
/// Gerçek GPS yok — sabit İstanbul/Beşiktaş konumu + CartoDB dark_matter tile.
class MapBackdrop extends StatelessWidget {
  const MapBackdrop({super.key});

  static const _besiktas = LatLng(41.0422, 29.0083);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        FlutterMap(
          options: const MapOptions(
            initialCenter: _besiktas,
            initialZoom: 15.5,
            interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://cartodb-basemaps-a.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.hizlaye.mobile',
            ),
          ],
        ),
        // Üstten/alttan kararma — Stitch'teki gradient overlay.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.scaffold,
                AppColors.scaffold.withValues(alpha: 0),
                AppColors.scaffold.withValues(alpha: 0.85),
              ],
              stops: const [0.0, 0.35, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

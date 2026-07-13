import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/location/location_provider.dart';
import '../../../core/map/map_style_provider.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../../core/widgets/slide_to_confirm.dart';
import '../../../core/widgets/stat_tile.dart';
import '../model/active_order.dart';
import '../viewmodel/active_order_viewmodel.dart';
import 'package:hizla_mobile/core/theme/theme_context.dart';

/// Stitch aktif-gorev.html birebir uyarlaması (Active Mission).
/// Gerçek harita: kurye/pickup/teslimat marker'ları + düz rota çizgisi.
class ActiveMissionScreen extends ConsumerStatefulWidget {
  const ActiveMissionScreen({super.key, this.orderId});

  final String? orderId;

  @override
  ConsumerState<ActiveMissionScreen> createState() => _ActiveMissionScreenState();
}

class _ActiveMissionScreenState extends ConsumerState<ActiveMissionScreen> {
  bool _delivering = false;

  Future<void> _onDelivered() async {
    final order = ref.read(activeOrderViewModelProvider).valueOrNull;
    final orderId = widget.orderId ?? order?.id;
    if (orderId == null || !mounted) return;
    setState(() => _delivering = true);
    if (mounted) {
      context.go(RoutePaths.qrVerify, extra: orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(activeOrderViewModelProvider);
    final order = orderState.valueOrNull;
    final courierLocation = ref.watch(courierLocationProvider).valueOrNull ??
        DeviceLocation.fallback;

    return Scaffold(
      backgroundColor: context.colors.scaffold,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _MissionMap(order: order, courierPoint: courierLocation.point),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlassPanel(
                        borderRadius: AppSpacing.radiusFull,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.near_me_rounded, color: context.colors.neonCyan, size: 18),
                            const SizedBox(width: AppSpacing.xs),
                            Text('Gazi Blv.', style: AppTypography.title.copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: context.colors.errorContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          border: Border.all(color: context.colors.error.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.emergency_rounded, color: context.colors.error, size: 18),
                            const SizedBox(width: AppSpacing.xs),
                            Text('YARDIM İSTE',
                                style: AppTypography.label.copyWith(color: context.colors.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.lg,
            child: SafeArea(
              top: false,
              child: GlassPanel(
                borderRadius: AppSpacing.radiusCard,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: AppColors.gradientEnd, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text('ACTIVE MISSION',
                            style: AppTypography.label.copyWith(color: context.colors.neonCyan)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(order?.restaurantName ?? 'Restoran', style: AppTypography.displayLarge),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        style: AppTypography.bodyMuted,
                        children: [
                          const TextSpan(text: 'Sipariş '),
                          TextSpan(
                            text: '#${order?.orderNumber ?? '----'}',
                            style: AppTypography.mono(fontSize: 14, color: context.colors.onSurface),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: StatTile(
                            icon: Icons.route_rounded,
                            label: 'MESAFE',
                            value: '${(order?.distanceKm ?? 0).toStringAsFixed(1)} km',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: StatTile(
                            icon: Icons.schedule_rounded,
                            label: 'TAHMİNİ SÜRE',
                            value: '${order?.etaMinutes ?? 0} dk',
                            valueColor: context.colors.neonCyan,
                            iconColor: context.colors.neonCyan,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SlideToConfirm(
                      label: 'Teslim Et',
                      confirmedLabel: 'Tamamlandı',
                      icon: Icons.double_arrow_rounded,
                      confirmedIcon: Icons.check_rounded,
                      trackGradient: AppGradients.primary,
                      onConfirmed: _delivering ? () {} : _onDelivered,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Gerçek harita: kurye + pickup + teslimat marker'ları, aralarında düz
/// rota çizgisi (OSRM entegrasyonu yok — basit polyline yeterli).
class _MissionMap extends ConsumerWidget {
  const _MissionMap({required this.order, required this.courierPoint});

  final ActiveOrder? order;
  final LatLng courierPoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileUrl = ref.watch(mapTileUrlProvider);
    final points = <LatLng>[courierPoint];
    final markers = <Marker>[
      Marker(
        point: courierPoint,
        width: 20,
        height: 20,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.neonCyan,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: context.colors.neonCyan.withValues(alpha: 0.6), blurRadius: 10)],
          ),
        ),
      ),
    ];

    if (order?.pickupLat != null && order?.pickupLng != null) {
      final pickup = LatLng(order!.pickupLat!, order!.pickupLng!);
      points.add(pickup);
      markers.add(_pinMarker(pickup, AppColors.gradientEnd, Icons.storefront_rounded));
    }
    if (order?.deliveryLat != null && order?.deliveryLng != null) {
      final delivery = LatLng(order!.deliveryLat!, order!.deliveryLng!);
      points.add(delivery);
      markers.add(_pinMarker(delivery, context.colors.error, Icons.flag_rounded));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FlutterMap(
          options: MapOptions(initialCenter: courierPoint, initialZoom: 14.5),
          children: [
            TileLayer(
              urlTemplate: tileUrl,
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.hizlaye.mobile',
            ),
            if (points.length > 1)
              PolylineLayer(
                polylines: [
                  Polyline(points: points, color: context.colors.neonCyan.withValues(alpha: 0.85), strokeWidth: 5),
                ],
              ),
            MarkerLayer(markers: markers),
          ],
        ),
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.colors.scaffold.withValues(alpha: 0.6),
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

  Marker _pinMarker(LatLng point, Color color, IconData icon) {
    return Marker(
      point: point,
      width: 32,
      height: 32,
      child: Icon(icon, color: color, size: 28, shadows: [Shadow(color: color, blurRadius: 8)]),
    );
  }
}

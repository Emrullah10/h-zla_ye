import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Gerçek cihaz konumu — GPS izni yoksa/reddedilirse Beşiktaş fallback yayar.
class DeviceLocation {
  const DeviceLocation({required this.point, required this.isReal});

  final LatLng point;
  final bool isReal;

  static const _besiktas = LatLng(41.0422, 29.0083);
  static const fallback = DeviceLocation(point: _besiktas, isReal: false);
}

Future<bool> _ensurePermission() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return false;

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  return permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
}

final courierLocationProvider = StreamProvider<DeviceLocation>((ref) async* {
  final granted = await _ensurePermission();
  if (!granted) {
    yield DeviceLocation.fallback;
    return;
  }

  final positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
  );

  await for (final position in positionStream) {
    yield DeviceLocation(
      point: LatLng(position.latitude, position.longitude),
      isReal: true,
    );
  }
});

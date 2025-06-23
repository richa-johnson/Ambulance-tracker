import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ambulance_tracker/controller/location_controller.dart';
import 'package:ambulance_tracker/services/driver_services.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:geolocator/geolocator.dart' as geo;

class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  final Location _location = Location();
  StreamSubscription<LocationData>? _subscription;
  LocationData? _lastUploaded;

  Future<void> startTracking({
    required LocationController controller,
    required BuildContext context,
  }) async {
    await stopTracking(); 
    controller.updateIsAccessingLocation(true);

    if (!await _ensureServiceEnabled(context)) {
      controller.errorDescription.value = 'GPS not enabled';
      controller.updateIsAccessingLocation(false);
      return;
    }

    if (!await _ensurePermission(context)) {
      controller.errorDescription.value = 'Location permission denied';
      controller.updateIsAccessingLocation(false);
      return;
    }
    final firstFix = await _location.getLocation();
    debugPrint(
      '📍 First location → lat=${firstFix.latitude}, lng=${firstFix.longitude}',
    );
    controller.updateDriveLocation(firstFix);

    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _subscription = _location.onLocationChanged.listen(
      (data) => _handleNewLocation(data, controller),
      onError: (e) => controller.errorDescription.value = e.toString(),
    );

    controller.updateIsAccessingLocation(false);
  }

  Future<void> stopTracking() async {
    await _subscription?.cancel();
    _subscription = null;
  }

Future<bool> _ensureServiceEnabled(BuildContext ctx) async {
  bool enabled = await _location.serviceEnabled();
  int cancelCount = 0;                               

  debugPrint('🛈 GPS enabled = $enabled');

  while (!enabled) {
    enabled = await _location.requestService();      
    if (enabled) return true;                      
    final retry = await showDialog<bool>(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('GPS required'),
        content: const Text(
            'Please enable GPS to track the ambulance.\nTap “Turn on GPS” to try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false), // Cancel
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),  // Retry
            child: const Text('Turn on GPS'),
          ),
        ],
      ),
    ) ?? false;

    debugPrint('🛈 GPS retry=$retry  cancelCount=${cancelCount + 1}');

    if (!retry) {
      cancelCount++;
      if (cancelCount >= 2) return false;            
    }
  }
  return true;
}


  Future<bool> _ensurePermission(BuildContext ctx) async {
    var status = await _location.hasPermission();
    int cancelCount = 0;

    while (status == PermissionStatus.denied) {
      status = await _location.requestPermission();

      if (status == PermissionStatus.granted ||
          status == PermissionStatus.grantedLimited)
        return true;

      final retry = await _showRetryDialog(ctx);
      if (!retry) {
        cancelCount++;
        if (cancelCount >= 2) return false; 
        continue; 
      }
    }

    if (status == PermissionStatus.deniedForever) {
      await _showSettingsDialog(ctx);
      return false;
    }

    return status == PermissionStatus.granted ||
        status == PermissionStatus.grantedLimited;
  }

  Future<void> _showInfoDialog(
    BuildContext ctx, {
    required String title,
    required String message,
  }) async {
    await showDialog<void>(
      context: ctx,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: Navigator.of(ctx).pop,
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<bool> _showRetryDialog(BuildContext ctx) async {
    final retry = await showDialog<bool>(
      context: ctx,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('Location required'),
            content: const Text(
              'We need your location to track the ambulance.\n\nTap “Try again” to allow access.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Try again'),
              ),
            ],
          ),
    );
    return retry ?? false;
  }

  Future<void> _showSettingsDialog(BuildContext ctx) async {
    await showDialog<void>(
      context: ctx,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('Permission permanently denied'),
            content: const Text(
              'Location permission is permanently denied.\nOpen app settings to enable it.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  handler.openAppSettings();
                  Navigator.of(ctx).pop();
                },
                child: const Text('Open settings'),
              ),
            ],
          ),
    );
  }

  Future<void> _handleNewLocation(
    LocationData data,
    LocationController controller,
  ) async {
    debugPrint('📍 lat=${data.latitude}, lng=${data.longitude}');
    controller.updateDriveLocation(data);

    if (_shouldUpload(data)) {
      _lastUploaded = data;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && data.latitude != null && data.longitude != null) {
        await uploadLocation(
          lat: data.latitude!,
          lng: data.longitude!,
          token: token,
        );
      }
    }
  }

  bool _shouldUpload(LocationData current) {
    if (_lastUploaded == null) return true;
    return geo.Geolocator.distanceBetween(
          _lastUploaded!.latitude!,
          _lastUploaded!.longitude!,
          current.latitude!,
          current.longitude!,
        ) >=
        10;
  }
}

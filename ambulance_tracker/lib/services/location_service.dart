import 'package:ambulance_tracker/controller/location_controller.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

class LocationService {
  LocationService.init();
  static LocationService instance = LocationService.init();

  final Location _location = Location();

  Future<bool> checkforserviceavailability() async {
    bool isEnabled = await _location.serviceEnabled();

    if (isEnabled) {
      return Future.value(true);
    }

    isEnabled = await _location.requestService();
    if (isEnabled) {
      return Future.value(true);
    }

    return Future.value(false);
  }

  Future<bool> checkForpermission() async {
    PermissionStatus status = await _location.hasPermission();

    if (status == PermissionStatus.denied) {
      status = await _location.requestPermission();

      if (status == PermissionStatus.granted) {
        //access location
        return true;
      }

      return false;
    }
    if (status == PermissionStatus.deniedForever) {
      Get.snackbar(
        "permission Needed",
        'we user permission to get your location inorder to track your ambulance',
        onTap: (snack) {
          handler.openAppSettings();
        },
      ).show();

      return false;
    }

    return Future.value(true);
  }

  Future<void> getUserLocation({required LocationController contoller}) async {
    contoller.updateIsAccessingLocation(true);

    if (!(await checkforserviceavailability())) {
      contoller.errorDescription.value = "service not enabled";
      contoller.updateIsAccessingLocation(false);
      return;
    }

    if (!(await checkForpermission())) {
      contoller.errorDescription.value = "Permission not given";

      contoller.updateIsAccessingLocation(false);

      return;
    }

    final LocationData data = await _location.getLocation();
    contoller.updateDriveLocation(data);
    contoller.updateIsAccessingLocation(false);
  }
}

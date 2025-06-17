import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  final RxBool isAccessingLocation = RxBool(false);
  final RxString errorDescription = RxString("");

  final Rx<LocationData?> driverLocation = Rx<LocationData?>(null);

  void updateIsAccessingLocation(bool b) {
    isAccessingLocation.value = b;
  }

  void updateDriveLocation(LocationData data) {
    driverLocation.value = data;
  }
}

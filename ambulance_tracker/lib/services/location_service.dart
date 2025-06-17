class LocationService {
  LocationService.init();
  static LocationService instance = LocationService.init();

 final  Location _location = Location();

  Future<bool> checkforserviceavailability() async {

    _location.serviceEnabled
  }
}

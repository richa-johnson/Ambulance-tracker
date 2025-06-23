import 'dart:convert';
import 'dart:async';
import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/controller/driver_booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ambulance_tracker/services/user_services.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geo;

class Trackpatient extends StatefulWidget {
  const Trackpatient({super.key});

  @override
  State<Trackpatient> createState() => TrackpatientState();
}

class TrackpatientState extends State<Trackpatient> {
  final MapController _mapController = MapController();
  LatLng? CurrentLocation;
  LatLng? destinationLocation;
  List<LatLng> routePoints = [];
  TextEditingController searchController = TextEditingController();
  bool mapMoved = false;
  geo.Position? _position;
  String _locationStatus = "Checking location...";
  String distanceText = '';
  String durationText = '';
  Timer? _refreshTimer;
  late int _bookingId;

  @override
  void initState() {
    super.initState();
    loadBookingData();

    _refreshTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      refreshDriverLocationOnly();
    });
  }

  Future<void> loadBookingData() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseURL/driver/confirmed-booking'),

      headers: {
        'Authorization': 'Bearer $token', // insert token dynamically
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pickupCoords = data['pickup_location'].split(',');
      final driverCoords = data['driver_location'].split(',');
      final int bookid = data['booking_id'];
      final pickupLatLng = LatLng(
        double.parse(pickupCoords[0]),
        double.parse(pickupCoords[1]),
      );
      final driverLatLng = LatLng(
        double.parse(driverCoords[0]),
        double.parse(driverCoords[1]),
      );

      setState(() {
        _bookingId = bookid;
        CurrentLocation = driverLatLng;
        destinationLocation = pickupLatLng;
      });

      fetchRoute(driverLatLng, pickupLatLng);
    } else {
      showMessage("No confirmed booking found");
    }
  }

  Future<void> searchAndDrawRoute(String placeName) async {
    if (CurrentLocation == null) return;

    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=$placeName&format=json&limit=1",
    );
    final response = await http.get(
      url,
      headers: {'User-Agent': 'FlutterMapLocationApp'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isEmpty) {
        showMessage("Place not found");
        return;
      }

      double destLat = double.parse(data[0]['lat']);
      double destLon = double.parse(data[0]['lon']);
      LatLng destination = LatLng(destLat, destLon);

      await fetchRoute(CurrentLocation!, destination);
    } else {
      showMessage("Geocoding failed");
    }
  }

  Future<void> refreshDriverLocationOnly() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseURL/driver/confirmed-booking'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final driverCoords = data['driver_location'].split(',');

      final driverLatLng = LatLng(
        double.parse(driverCoords[0]),
        double.parse(driverCoords[1]),
      );

      setState(() {
        CurrentLocation = driverLatLng;
      });

      // Refresh the route from new driver location to patient location
      if (destinationLocation != null) {
        fetchRoute(CurrentLocation!, destinationLocation!);
      }
    }
  }

  Future<void> fetchRoute(LatLng start, LatLng end) async {
    final url = Uri.parse(
      "http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0];

      final geometry = route['geometry']['coordinates'];
      final distance = route['distance'];
      final duration = route['duration'];

      List<LatLng> points =
          geometry.map<LatLng>((coord) => LatLng(coord[1], coord[0])).toList();

      setState(() {
        routePoints = points;
        destinationLocation = end;
        distanceText = (distance / 1000).toStringAsFixed(2) + " km";
        durationText = (duration / 60).toStringAsFixed(0) + " mins";
        _mapController.move(start, 15);
      });
    } else {
      showMessage("Route fetch failed");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void moveToCurrentLocation() {
    if (CurrentLocation != null) {
      _mapController.move(CurrentLocation!, 15);
    } else {
      showMessage("Current location not available");
    }
  }

  Future<void> _handleComplete() async {
    final ctrl = Get.find<DriverBookingController>();
    try {
      // optional: show progress UI
      await ctrl.completeRide(_bookingId);
      _refreshTimer?.cancel(); // stop 5-second polling
      if (mounted) {
        Get.snackbar('Ride Completed', 'You are now available');
        // navigate to the driver dashboard (adjust route name)
        Navigator.pop(context);
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not complete ride');
    }
  }

  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Image.asset(
            'assets/title.png',
            fit: BoxFit.contain,
            height: 180,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(159, 13, 55, 1.0),
              Color.fromRGBO(189, 83, 114, 1.0),
            ],
          ),
        ),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
          left: 10.0,
          right: 10.0,
          bottom: 10.0,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: CurrentLocation ?? const LatLng(0, 0),
                        initialZoom: 15,
                        minZoom: 0,
                        maxZoom: 100,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        ),
                        const CurrentLocationLayer(
                          style: LocationMarkerStyle(
                            marker: DefaultLocationMarker(
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.white,
                              ),
                            ),
                            markerSize: Size(35, 35),
                            markerDirection: MarkerDirection.heading,
                          ),
                        ),
                        if (destinationLocation != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: CurrentLocation!,
                                width: 80,
                                height: 80,
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.local_hospital,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                    Text(
                                      "Ambulance",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Marker(
                                point: destinationLocation!,
                                width: 80,
                                height: 80,
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.person_pin_circle,
                                      color: Colors.green,
                                      size: 40,
                                    ),
                                    Text(
                                      "Patient",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        if (routePoints.isNotEmpty)
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: routePoints,
                                strokeWidth: 6.0,
                                color: Colors.red,
                              ),
                            ],
                          ),
                      ],
                    ),
                    if (routePoints.isNotEmpty)
                      Positioned(
                        bottom: 80,
                        left: 20,
                        right: 20,
                        child: Card(
                          color: Colors.white.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Distance: $distanceText",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Duration: $durationText",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    _handleComplete();
                                    // or Navigator.push to dashboard
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Completed',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: const Color(0xFF9F0D37),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: moveToCurrentLocation,
                        backgroundColor: Colors.blue,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

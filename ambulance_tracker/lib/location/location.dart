import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geo;

class RoutingPage extends StatefulWidget {
  const RoutingPage({super.key});

  @override
  State<RoutingPage> createState() => RoutingPageState();
}

class RoutingPageState extends State<RoutingPage> {
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

  @override
  void initState() {
    super.initState();
    initLocationTracking();
  }

  Future<void> initLocationTracking() async {
    try {
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationStatus = "Location services are disabled.";
        });
        await geo.Geolocator.openLocationSettings();
        return;
      }

      geo.LocationPermission permission =
          await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          setState(() {
            _locationStatus = "Location permissions are denied";
          });
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        setState(() {
          _locationStatus = "Location permissions are permanently denied";
        });
        return;
      }

      geo.Position position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );

      LatLng userLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _position = position;
        CurrentLocation = userLocation;
        _locationStatus =
            "Location: ${position.latitude}, ${position.longitude}";
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (CurrentLocation != null) {
          _mapController.move(CurrentLocation!, 15);
        }
      });
    } catch (e) {
      setState(() {
        _locationStatus = "Location error: $e";
      });
      debugPrint("Location error: $e");
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search destination",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      searchAndDrawRoute(searchController.text.trim());
                    },
                  ),
                ],
              ),
            ),
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
                                point: destinationLocation!,
                                width: 80,
                                height: 80,
                                child: const Icon(
                                  Icons.location_on,
                                  size: 40,
                                  color: Colors.green,
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

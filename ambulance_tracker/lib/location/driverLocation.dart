import 'dart:convert';
import 'package:ambulance_tracker/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class DriverLocation extends StatefulWidget {
  const DriverLocation({super.key});

  @override
  State<DriverLocation> createState() => DriverLocationState();
}

class DriverLocationState extends State<DriverLocation> {
  final MapController _mapController = MapController();
  LatLng? destinationLocation;
  List<LatLng> routePoints = [];
  TextEditingController searchController = TextEditingController();
  String distanceText = '';
  String durationText = '';

  final LatLng adminBaseLocation = LatLng(6.9271, 79.8612); // Set to your desired base

  Future<void> searchDriverAndDrawLocation(String query) async {
    if (query.isEmpty) {
      showMessage("Please enter a driver ID or name");
      return;
    }

    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse('$driverLocURL/$encodedQuery');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final double lat = data['latitude'];
        final double lon = data['longitude'];
        LatLng driverLocation = LatLng(lat, lon);

        setState(() {
          destinationLocation = driverLocation;
        });

        _mapController.move(driverLocation, 15);
        
      } else {
        showMessage("Driver not found");
      }
    } catch (e) {
      showMessage("Error fetching driver location");
      print("Error: $e");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
                        hintText: "Search driver ID",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      searchDriverAndDrawLocation(searchController.text.trim());
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
                        initialCenter: destinationLocation ?? adminBaseLocation,
                        initialZoom: 15,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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

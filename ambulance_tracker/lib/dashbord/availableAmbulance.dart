import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/driver_model.dart'; // adjust relative path
import '../constant.dart';
import 'custom_card.dart';
import 'package:ambulance_tracker/dashbord/patientDetailsForm.dart';

class AvailableAmbulance extends StatefulWidget {
  final String pickupLocation;
  final int patientCount;
  final List<Map<String, dynamic>> patientList;

  const AvailableAmbulance({
    Key? key,
    required this.pickupLocation,
    required this.patientCount,
    required this.patientList,
  }) : super(key: key);

  @override
  State<AvailableAmbulance> createState() => _AvailableAmbulanceState();
}

class _AvailableAmbulanceState extends State<AvailableAmbulance> {
  final ValueNotifier<bool> bookingLocked = ValueNotifier(
    false,
  ); // <‑‑ ONE shared instance

  @override
  void initState() {
    super.initState();
    fetchDrivers().then((drivers) {
      setState(() {
        allDrivers = drivers;
        filteredDrivers = drivers;
      });
    });
    _driverFuture = fetchDrivers(); // ✅ assign the real future
  }

  List<Driver> allDrivers = [];
  List<Driver> filteredDrivers = [];
  List<String> selectedFacilities = [];
  String? selectedSector;
  String? selectedCapacity;

  @override
  void dispose() {
    bookingLocked.dispose();
    super.dispose();
  }

  List<Driver> drivers = [];
  Map<String, dynamic>? userDetails;
  bool isLoadingUser = true;
  late Future<List<Driver>> _driverFuture;

  Future<List<Driver>> loadDrivers() async {
    final fetched = await fetchDrivers();
    return fetched;
  }

  Future<List<Driver>> fetchDrivers() async {
    final res = await http.get(Uri.parse(getAvailabledriversURL));
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
        debugPrint(jsonEncode(list));  // or print(data);
      final availableDrivers =
          list.where((e) => e['status'] == 'available').toList();
      final parts = widget.pickupLocation.split(',');
      final pickupLat = double.tryParse(parts[0].trim()) ?? 0.0;
      final pickupLng = double.tryParse(parts[1].trim()) ?? 0.0;
      availableDrivers.sort((a, b) {
        final aParts = (a['location'] ?? '0,0').split(',');
        final bParts = (b['location'] ?? '0,0').split(',');
        final aLat = double.tryParse(aParts[0].trim()) ?? 0.0;
        final aLng = double.tryParse(aParts[1].trim()) ?? 0.0;
        final bLat = double.tryParse(bParts[0].trim()) ?? 0.0;
        final bLng = double.tryParse(bParts[1].trim()) ?? 0.0;
        final distA = calculateDistance(pickupLat, pickupLng, aLat, aLng);
        final distB = calculateDistance(pickupLat, pickupLng, bLat, bLng);
        return distA.compareTo(distB);
      });
      final List<Driver> fetchedDrivers = availableDrivers.map((e) {
      final driver = Driver.fromJson(e);
      final locationParts = (e['location'] ?? '0,0').split(',');
      final lat = double.tryParse(locationParts[0].trim()) ?? 0.0;
      final lng = double.tryParse(locationParts[1].trim()) ?? 0.0;
      driver.distance = calculateDistance(pickupLat, pickupLng, lat, lng);
      return driver;
    }).toList();

    setState(() {
      drivers = fetchedDrivers;
    });

    return fetchedDrivers;
  }
  throw Exception('Failed to load drivers');
}

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  void applyFilters() {
    setState(() {
      filteredDrivers =
          allDrivers.where((driver) {
            final sectorMatch =
                selectedSector == null || driver.sector == selectedSector;
            final capacityMatch =
                selectedCapacity == null || driver.capacity == selectedCapacity;
            return sectorMatch && capacityMatch;
          }).toList();
    });
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
              Color.fromRGBO(159, 13, 55, 1),
              Color.fromRGBO(189, 83, 114, 1),
            ],
          ),
        ),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
          left: 10,
          right: 10,
          bottom: 10,
        ),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                // ─── pink header strip with back arrow ─────────────────────
                Container(
                  height: 76,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(227, 185, 197, 1),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, size: 30),
                          onPressed:
                              () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const patientDetailsForm(),
                                ),
                              ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            _showFilterPopup(details.globalPosition);
                          },
                          child: const Icon(
                            Icons.filter_list,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                FutureBuilder<List<Driver>>(
                  future: _driverFuture,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snap.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text('Error: ${snap.error}'),
                      );
                    }

                    final drivers = snap.data ?? [];
                    final showDrivers =
                        filteredDrivers.isNotEmpty ? filteredDrivers : drivers;

                    if (showDrivers.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No available ambulances'),
                      );
                    }

                    return Column(
                      children:
                      showDrivers
                      .map(
                        (d) => CustomCard(
                          key: ValueKey(d.id),
                          driver: d,
                          pickupLocation: widget.pickupLocation,
                          patientCount: widget.patientCount,
                          patientList: widget.patientList,
                          bookingLocked: bookingLocked,
                          onBookingResult: (result) {
                            if (result != null &&
                                result['expired'] == true) {
                              setState(() {
                                drivers.removeWhere(
                                  (driver) =>
                                      driver.id == result['driverId'],
                                );
                                bookingLocked.value = false;
                              });

                              loadDrivers();

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    '⏱️ Booking expired. Please choose another ambulance.',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      )
                      .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterPopup(Offset position) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final sectors = allDrivers.map((e) => e.sector).toSet().toList();
    final capacities = allDrivers.map((e) => e.capacity).toSet().toList();

    // Persist temporary state outside builder
    String? tempSector = selectedSector;
    String? tempCapacity = selectedCapacity;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(position, position),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sector',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        sectors.map((s) {
                          final isSelected = tempSector == s;
                          return ChoiceChip(
                            label: Text(
                              s,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: Color.fromRGBO(87, 24, 44, 2),
                            backgroundColor: Colors.grey[200],
                            onSelected: (_) {
                              setModalState(() {
                                tempSector = (tempSector == s) ? null : s;
                              });
                            },
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Capacity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        capacities.map((c) {
                          final isSelected = tempCapacity == c;
                          return ChoiceChip(
                            label: Text(
                              c,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: Color.fromRGBO(87, 24, 44, 2),
                            backgroundColor: Colors.grey[200],
                            onSelected: (_) {
                              setModalState(() {
                                tempCapacity = (tempCapacity == c) ? null : c;
                              });
                            },
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedSector = tempSector;
                            selectedCapacity = tempCapacity;
                          });
                          applyFilters();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            color: Color.fromRGBO(87, 24, 44, 1),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedSector = null;
                            selectedCapacity = null;
                          });
                          applyFilters();
                          Navigator.pop(context);
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

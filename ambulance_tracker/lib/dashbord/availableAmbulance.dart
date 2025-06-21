import 'dart:convert';
import 'package:ambulance_tracker/dashbord/patientDetailsForm.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/driver_model.dart'; // adjust relative path
import '../constant.dart';
import 'custom_card.dart'; // put CustomCard in its own file or below

class AvailableAmbulance extends StatefulWidget {
  final String pickupLocation;
  final int patientCount;
  final List<Map<String, dynamic>> patientList;

  const AvailableAmbulance({
    Key? key,
    required this.pickupLocation,
    required this.patientCount,
    required this.patientList,
  }) : super(key: key); // <‑‑ initializer list only; no body here

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
    _driverFuture = fetchDrivers(); // ✅ assign the real future
  }

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
      final List<Driver> fetchedDrivers =
          list.map((e) => Driver.fromJson(e)).toList();
      setState(() {
        drivers = fetchedDrivers;
      });
      return fetchedDrivers;
    } else {
      throw Exception('Failed to load drivers');
    }
  }

  // ─────────────────────────── UI ────────────────────────────
  List<String> selectedFacilities = [];

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

      // ─── gradient background ─────────────────────────────────────────────
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
                      ],
                    ),
                  ),
                ),

                // ─── Sort / Filter bar ────────────────────────────────────
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(107),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Sort -------------------------------------------------
                      Expanded(
                        child: InkWell(
                          onTap: _openSortSheet,
                          child: _SortOrFilterTile(
                            icon: Icons.sort,
                            label: 'Sort',
                          ),
                        ),
                      ),
                      Container(width: 1, height: 30, color: Colors.grey[300]),
                      // Filter ----------------------------------------------
                      Expanded(
                        child: InkWell(
                          onTap: _openFilterSheet,
                          child: _SortOrFilterTile(
                            icon: Icons.filter_list,
                            label: 'Filter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Driver list (FutureBuilder inside) ───────────────────
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
                    if (drivers.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No available ambulances'),
                      );
                    }

                    return Column(
                      children:
                          drivers
                              .map(
                                (d) => CustomCard(
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
                                        SnackBar(
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

  // ─────────── helpers for Sort / Filter bottom sheets ───────────
  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.near_me),
                title: const Text('Sort by Nearest'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: implement nearest sorting
                },
              ),
              ListTile(
                leading: const Icon(Icons.timer),
                title: const Text('Sort by Availability'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: implement availability sorting
                },
              ),
            ],
          ),
    );
  }

  void _openFilterSheet() {
    const facilities = ['Oxygen', 'ICU', 'Ventilator'];
    List<String> tempSelected = [...selectedFacilities];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Facilities',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...facilities.map(
                    (f) => CheckboxListTile(
                      title: Text(f),
                      value: tempSelected.contains(f),
                      onChanged:
                          (v) => setModalState(() {
                            v == true
                                ? tempSelected.add(f)
                                : tempSelected.remove(f);
                          }),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => selectedFacilities = tempSelected);
                      Navigator.pop(context);
                      // TODO: apply filtering logic to driver list
                    },
                    child: const Text('Apply Filter'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ───────────── small helper widget for the Sort / Filter row ────────────────
class _SortOrFilterTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SortOrFilterTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.black),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

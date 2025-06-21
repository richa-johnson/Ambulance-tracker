import 'dart:convert';

import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/models/driver_model.dart';
import 'package:ambulance_tracker/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomCard extends StatefulWidget {
  final Driver driver;
  final String pickupLocation;
  final int patientCount;
  final List<Map<String, dynamic>> patientList;
  final ValueNotifier<bool> bookingLocked;

  const CustomCard({
    Key? key,
    required this.driver,
    required this.pickupLocation,
    required this.patientCount,
    required this.patientList,
    required this.bookingLocked,
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isPressed = false; // this card’s button is now green/locked
  bool isSubmitting = false; // show spinner while waiting
  final ValueNotifier<bool> bookingLocked = ValueNotifier<bool>(false);

  Future<int> _createBooking(String token) async {
    final res = await http.post(
      Uri.parse('$baseURL/booking/store'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'driver_id': widget.driver.id,
        'p_location': widget.pickupLocation,
        'p_count': widget.patientCount,
      }),
    );
    if (res.statusCode == 201) {
      return jsonDecode(res.body)['booking_id'] as int;
    }
    throw Exception('Booking failed: ${res.body}');
  }

  Future<void> _sendPatients(String token, int bookingId) async {
    final res = await http.post(
      Uri.parse('$baseURL/booking/$bookingId/patients'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'patients': widget.patientList}),
    );
    if (res.statusCode != 204) {
      throw Exception('Patient upload failed: ${res.body}');
    }
  }

  Future<void> _bookDriver() async {
    setState(() => isSubmitting = true);

    try {
      final token = await getToken();
      final bookingId = await _createBooking(token); // your existing API call
      if (bookingId != null) {
        setState(() => isPressed = true);
        widget.bookingLocked.value = true; // lock every card
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Booking failed: $e')));
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.driver; // shorthand

    return Card(
      margin: const EdgeInsets.all(12),
      color: const Color(0xFF9F0D37),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              d.name,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.white, size: 18),
                const SizedBox(width: 5),
                Text(
                  d.phoneno,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 25),
                Text(
                  d.vehicleno,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const Spacer(),
             ValueListenableBuilder<bool>(
                valueListenable: widget.bookingLocked,
                builder: (_, locked, __) {
                  final disabled = isPressed || locked || isSubmitting;
                  return ElevatedButton(
                    onPressed: disabled ? null : _bookDriver,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isPressed ? Colors.green : Colors.white,
                      minimumSize: const Size(100, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            isPressed ? 'Request Sent' : 'Book Now',
                            style: TextStyle(
                              fontSize: 12,
                              color: isPressed
                                  ? Colors.white
                                  : const Color(0xFF9F0D37),
                            ),
                          ),
                  );
                },
              ),   ],
            ),

            const SizedBox(height: 8),
            Container(height: 1, color: const Color(0xFFE7A4A4), width: 300),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFE7A4A4),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder:
                          (_) => _DriverDetailsSheet(
                            name: d.name,
                            sector: d.sector,
                            district: d.disrtict ,
                            capacity: d.capacity,
                            facilities: d.facilities,
                          ),
                    );
                  },
                  child: const Text('View More'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverDetailsSheet extends StatelessWidget {
  final String name;
  final String district;
  final String capacity;
  final String sector;
  final List<String> facilities;

  const _DriverDetailsSheet({
    required this.name,
    required this.district,
    required this.capacity,
    required this.facilities,
    required this.sector,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 3,
                color: const Color.fromARGB(115, 110, 108, 108),
              ),
              const SizedBox(height: 5),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9F0D37),
                ),
              ),
              const SizedBox(height: 12),
              // Details list -------------------------------------------------
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sector : $sector',
                      style: const TextStyle(
                        color: Color(0xFF9F0D37),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Capacity: $capacity',
                      style: const TextStyle(
                        color: Color(0xFF9F0D37),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Facilities',
                      style: TextStyle(
                        color: Color(0xFF9F0D37),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    ...facilities.map(
                      (f) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '• $f',
                          style: const TextStyle(
                            color: Color(0xFF9F0D37),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

  const CustomCard({
    Key? key,
    required this.driver,
    required this.pickupLocation,
    required this.patientCount,
    required this.patientList,
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isPressed = false;

  Future<int> _createBooking(String token) async {
    final res = await http.post(
      Uri.parse('$baseURL/booking'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'driver_id':  widget.driver.id,
        'p_location': widget.pickupLocation,
        'p_count':    widget.patientCount,
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
    try {
      final token = await getToken();           // or readAuthToken()
      final id    = await _createBooking(token);
      await _sendPatients(token, id);

      setState(() => isPressed = true);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Request sent!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      color: const Color(0xFF9F0D37),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.driver.name,
                style: const TextStyle(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(widget.driver.phoneno,
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isPressed ? Colors.green : Colors.white,
              ),
              onPressed: isPressed ? null : _bookDriver,
              child: Text(
                isPressed ? 'Request Sent' : 'Book Now',
                style: TextStyle(
                  color:
                      isPressed ? Colors.white : const Color(0xFF9F0D37),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/models/booking.dart';
import 'package:ambulance_tracker/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sendPatients(
  int bookingId,
  List<Map<String, dynamic>> patients,
) async {
  final url = Uri.parse('https://$baseURL/api/bookings/$bookingId/patients');
  String token = await getToken();
  final res = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // Replace with actual token
    },
    body: jsonEncode({'patients': patients}),
  );

  if (res.statusCode == 204) {
    print('✅ Patients successfully submitted');
  } else {
    print('❌ Failed to send patients: ${res.statusCode}');
    print(res.body);
    throw Exception('Failed to submit patients');
  }
}

class BookingService {
  Future<List<Booking>> getPendingBookings() async {
    final token = await getToken();
    final url = Uri.parse('$baseURL/driver/pending-bookings');
    final res = await http
        .get(url, headers: {'Authorization': 'Bearer $token'})
        .timeout(const Duration(seconds: 8));

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as List<dynamic>;
      // print('🟢 Raw booking list: ${res.body}');
      return body.map((e) => Booking.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch bookings');
    }
  }

  Future<void> confirm(int id) async {
    final token = await getToken();

    final url = Uri.parse('$baseURL/booking/$id/confirm');
    await http.post(url, headers: {'Authorization': 'Bearer $token'});
  }

  Future<void> cancel(int id) async {
    final token = await getToken();
    final url = Uri.parse('$baseURL/booking/$id/cancel');

    final res = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200) {
      print('❌ Confirm failed: ${res.statusCode} — ${res.body}');
      throw Exception('Booking confirm failed');
    }
  }

  Future<bool> fetchAvailability() async {
    final token = await getToken();
    final res = await http.get(
      Uri.parse('$baseURL/driver/status'), // <-- adjust if different
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    debugPrint('🔎  /driver/status → ${res.statusCode}');
    debugPrint('🔎  Response body: ${res.body}');
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final status =
          (data['status'] ?? data['driver_status'] ?? '')
              .toString()
              .toLowerCase()
              .trim();
      debugPrint('🔎  Parsed status = $status');
      return status == 'available';
    }

    debugPrint('🔴 fetchAvailability FAILED');
    return false; // default to unavailable on failure
  }

  Future<void> completeRide(int bookingId) async {
    final token = await getToken();
    final res = await http.post(
      Uri.parse('$baseURL/booking/$bookingId/complete'), // endpoint name
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (res.statusCode != 200) {
      throw Exception(
        'completeRide failed → '
        '${res.statusCode}: ${res.body}',
      );
    }
  }
}

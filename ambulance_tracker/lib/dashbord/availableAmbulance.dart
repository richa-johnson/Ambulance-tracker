import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/driver_model.dart'; // adjust relative path
import '../constant.dart';
import 'custom_card.dart'; // put CustomCard in its own file or below
import 'package:shared_preferences/shared_preferences.dart';

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
  Map<String, dynamic>? userDetails;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final user = await fetchUserDetails();
    if (user != null) {
      debugPrint('User ID: ${user['id']}');
      debugPrint('Name: ${user['name']}');
      debugPrint('Email: ${user['mail']}');
      debugPrint('Phone: ${user['phone_no']}');
      debugPrint('District: ${user['district']}');
    } else {
      debugPrint('Failed to fetch user details.');
    }

    setState(() {
      userDetails = user;
      isLoadingUser = false;
    });
  }

  Future<Map<String, dynamic>?> fetchUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) return null;

    try {
      final response = await http.get(
        Uri.parse('$baseURL/user/UserDetails'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized. Possibly invalid token.");
      } else {
        debugPrint('Failed to fetch user. Status: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
    }
    return null;
  }

  Future<List<Driver>> fetchDrivers() async {
    final res = await http.get(Uri.parse(getAvailabledriversURL));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Driver.fromJson(e)).toList();
    }
    throw Exception('Failed to load drivers');
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Ambulances')),
      body: FutureBuilder<List<Driver>>(
        future: fetchDrivers(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text('${snap.error}'));

          final drivers = snap.data!;
          return ListView(
            children:
                drivers
                    .map(
                      (d) => CustomCard(
                        driver: d,
                        pickupLocation: widget.pickupLocation,
                        patientCount: widget.patientCount,
                        patientList: widget.patientList,
                      ),
                    )
                    .toList(),
          );
        },
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/driver_model.dart';         
import '../constant.dart';
import 'custom_card.dart';                  

class AvailableAmbulance extends StatefulWidget {
  /// REQUIRED DATA coming from patientDetailsForm
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
            children: drivers.map(
              (d) => CustomCard(
                driver:         d,
                pickupLocation: widget.pickupLocation,
                patientCount:   widget.patientCount,
                patientList:    widget.patientList,
              ),
            ).toList(),
          );
        },
      ),
    );
  }
}
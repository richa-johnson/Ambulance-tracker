import 'package:flutter/material.dart';

class Driver {
  final int id;
  final String name;
  final String phoneno;
  final String vehicleno;
  final String sector;
  final String capacity;
  final String district;
  final List<String> facilities;

  Driver({
    required this.id,
    required this.name,
    required this.phoneno,
    required this.vehicleno,
    required this.sector,
    required this.capacity,
    required this.district,
    required this.facilities,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    final rawFacilities = json['facilities'];

    List<String> parsedFacilities;
    if (rawFacilities is List) {
      parsedFacilities = rawFacilities.map((e) => e.toString().trim()).toList();
    } else if (rawFacilities is String) {
      parsedFacilities = rawFacilities.split(',').map((e) => e.trim()).toList();
    } else {
      parsedFacilities = [];
    }

    return Driver(
      id: int.parse(json['slno'].toString()),
      name: json['name'],
      phoneno: json['phoneno'],
      vehicleno: json['vehicleno'],
      district: json['district'],
      sector: json['sector'],
      capacity: json['capacity']?.toString() ?? '',
      facilities: parsedFacilities,
    );
  }
}

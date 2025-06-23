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
    List<String> fac = [];
    if (rawFacilities is List) {
      fac =
          rawFacilities.map<String>((e) {
            if (e is Map && e.containsKey('facility')) {
              return e['facility'].toString().trim();
            }
            return e.toString().trim();
          }).toList();
    }

    return Driver(
      id: json['driver_id'],
      name: json['driver_name'],
      phoneno: json['driver_phone'],
      vehicleno: json['driver_vehno'],
      sector: json['driver_sector'],
      capacity: json['driver_capacity'].toString(),
      district: json['driver_district'],
      facilities: fac,
    );
  }

  Map<String, dynamic> toJson() => {
    'driver_id': id,
    'name': name,
    'phone': phoneno,
    'vehno': vehicleno,
    'sector': sector,
    'capacity': capacity,
    'district': district,
    'facilities': facilities,
  }..removeWhere((_, v) => v == null);
}
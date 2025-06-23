import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';
import '../services/user_services.dart';
import '../models/driver_model.dart';

class DriverProfileService {
  final String _base = '$baseURL/driver/profile';

  Map<String,String> _headers(String t) => {

    'Authorization': 'Bearer $t',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<Driver> fetch() async {
    final token = await getToken();
 

    final res = await http.get(Uri.parse(_base), headers: _headers(token));
   
    if (res.statusCode == 200) return Driver.fromJson(jsonDecode(res.body));
    throw Exception('fetchDriverProfile → ${res.statusCode}');
  }

  Future<void> update(Driver d) async {
    final res = await http.put(Uri.parse(_base),
      headers: _headers(await getToken()),
      body: jsonEncode(d.toJson()),
    );
    if (res.statusCode != 200) {
      final msg = (jsonDecode(res.body)['message'] ?? 'Unknown error').toString();
      throw Exception('updateDriverProfile → $msg');
    }
  }
}
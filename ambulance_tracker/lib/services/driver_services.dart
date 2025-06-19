
import 'dart:convert';

import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/models/api_response.dart';
import 'package:ambulance_tracker/models/user.dart';
import 'package:ambulance_tracker/registration/password.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> uploadLocation({
  required double lat,
  required double lng,
  required String token,
}) async {
  final res = await http.post(
    Uri.parse('$baseURL/driver/location'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'latitude': lat,
      'longitude': lng,
    }),
  );

  debugPrint('🚚 upload status=${res.statusCode} body=${res.body}');
}

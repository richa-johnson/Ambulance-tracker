import 'dart:convert';
import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/services/user_services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sendPatients(
  int bookingId,
  List<Map<String, dynamic>> patients,
) async {
  final url = Uri.parse(
    'https://$baseURL/api/bookings/$bookingId/patients',
  );
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

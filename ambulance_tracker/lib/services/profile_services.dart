import 'dart:convert';
import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/models/user.dart';
import 'package:ambulance_tracker/services/user_services.dart'; // getToken()
import 'package:http/http.dart' as http;

class ProfileService {
  Future<Map<String, dynamic>> fetch() async {
    final res = await http.get(
      Uri.parse('$baseURL/profile'),
      headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Accept': 'application/json',
      },
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('fetchProfile → ${res.statusCode}');
  }

  Future<void> update(User user) async {
    final res = await http.put(
      Uri.parse('$baseURL/profile'),
      headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );
    if (res.statusCode != 200) {
      final msg = jsonDecode(res.body)['message'] ?? 'Unknown error';
      throw Exception('updateProfile → $msg');
    }
  }
}

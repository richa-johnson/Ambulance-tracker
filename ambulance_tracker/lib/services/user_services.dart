//login
import 'dart:convert';

import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/models/api_response.dart';
import 'package:ambulance_tracker/models/user.dart';
import 'package:ambulance_tracker/registration/password.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  debugPrint('EMAIL SENT: "$email"');
  debugPrint('PASS  SENT: "$password"');

  try {
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },

      body: jsonEncode({'email': email, 'password': password}),
    );

    switch (response.statusCode) {
      case 200:
        final decoded = jsonDecode(response.body);

        final role = decoded['role'];
        final userJson = decoded['data']['user'];
        final token = decoded['data']['token'];

        final user =
            User.fromJson(userJson)
              ..token = token
              ..role = role;
        apiResponse.data = user;
        apiResponse.error = null;
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

//get user details
Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(userURL),
      headers: {'Accept': 'aplication/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;

      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

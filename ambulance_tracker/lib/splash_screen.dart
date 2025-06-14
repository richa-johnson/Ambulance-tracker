import 'dart:async';
import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/dashbord/userdashbordScreen.dart';
import 'package:ambulance_tracker/models/api_response.dart';
import 'package:ambulance_tracker/registration/login.dart';
import 'package:ambulance_tracker/services/user_services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ambulance_tracker/registration/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 
  @override
  void initState() {
    super.initState();

    _loadUserInfo();
  }

  void _loadUserInfo() async {
     await Future.delayed(const Duration(seconds: 2));
    String token = await getToken();
    if (token .isEmpty) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => RegisterScreen()),
        (route) => false,
      );
    } else {
      ApiResponse response = await getUserDetail();
      if (response.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (Context) => userdashboard()),
          (route) => false,
        );
      } else if (response.error == unauthorized) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RegisterScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(159, 13, 55, 1.0),
              Color.fromRGBO(189, 83, 114, 1.0),
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/title.png',
            fit: BoxFit.contain,
            height: 278,
          ).animate().fadeIn(duration: 2000.ms),
        ),
      ),
    );
  }
}

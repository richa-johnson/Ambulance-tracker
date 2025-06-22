import 'package:ambulance_tracker/controller/driver_booking_controller.dart';
import 'package:ambulance_tracker/dashbord/admindashboard.dart';
import 'package:ambulance_tracker/dashbord/trackAmbulanceScreen.dart';
import 'package:ambulance_tracker/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'resQroute',
      home: SplashScreen(),
    );
  }
}


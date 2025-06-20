import 'package:ambulance_tracker/dashbord/admindashboard.dart';
import 'package:ambulance_tracker/dashbord/trackAmbulanceScreen.dart';
import 'package:ambulance_tracker/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'resQroute',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: AdminDashboard(),
    );
  }
}

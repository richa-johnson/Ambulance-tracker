import 'package:ambulance_tracker/dashbord/driverEdit.dart';
import 'package:ambulance_tracker/dashbord/patientDetailsForm.dart';
import 'package:ambulance_tracker/dashbord/userEdit.dart';
import 'package:ambulance_tracker/dashbord/userHistory.dart';
import 'package:ambulance_tracker/dashbord/userdashbordScreen.dart';
import 'package:ambulance_tracker/registration/driver.dart';
import 'package:ambulance_tracker/registration/login.dart';
import 'package:ambulance_tracker/registration/otpverification.dart';
import 'package:ambulance_tracker/registration/password.dart';
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
      theme: ThemeData(
       primarySwatch:Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      home: UserHistory(),
    );
  }
}

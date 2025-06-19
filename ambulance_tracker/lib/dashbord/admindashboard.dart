import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/dashbord/activityHistory.dart';
import 'package:ambulance_tracker/dashbord/driverDetails.dart';
import 'package:ambulance_tracker/dashbord/userDetails.dart';
import 'package:ambulance_tracker/registration/login.dart';
import 'package:ambulance_tracker/services/user_services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Future<bool> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("No token found.");
      return false;
    }

    final response = await http.post(
      Uri.parse(logoutURL),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print("Logout response: ${response.statusCode}");

    if (response.statusCode == 200) {
      await prefs.remove('token');
      await prefs.remove('userId');
      return true;
    } else {
      if (!mounted) return false;
      ScaffoldMessenger.of(
        context
      ).showSnackBar(SnackBar(content: Text("Logout failed")));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Image.asset(
            'assets/title.png',
            fit: BoxFit.contain,
            height: 180,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

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
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
          left: 10.0,
          right: 10.0,
          bottom: 10.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 76,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(227, 185, 197, 1),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                    bottom: Radius.circular(0),
                  ),
                ),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    ),
                    TextButton(
                      onPressed: () async {
                        print("Logout button pressed");
                        final success = await _logout(context);
                        print("Logout success: $success");
                        if (!mounted) return;
                        if (success) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => LoginPage()),
                            (route) => false,
                          );
                        }
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 381,
                // height: 764,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: 361,
                      height: 231,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(187, 51, 90, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -50, // move up to show only quarter
                            right: -60, // move right to show only quarter
                            child: Container(
                              width: 281,
                              height: 211,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/4767.png',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 40,
                            left: 40,
                            child: Text(
                              'CARE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2), // x and y offset
                                    blurRadius: 4.0,
                                    color: Colors.black.withOpacity(1.0),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            top: 90,
                            left: 40,

                            child: Text(
                              'CONTROL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2), // x and y offset
                                    blurRadius: 4.0,
                                    color: Colors.black.withOpacity(1.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 140,
                            left: 40,

                            child: Text(
                              'CONNEXT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2), // x and y offset
                                    blurRadius: 4.0,
                                    color: Colors.black.withOpacity(1.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: 330,
                height: 393,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(217, 217, 217, 1),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetails(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                        minimumSize: Size(265, 55),
                      ),
                      child: Text(
                        "USER DETAILS",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1.0),
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DriverDetails(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                        minimumSize: Size(265, 55),
                      ),
                      child: Text(
                        "DRIVER DETAILS",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1.0),
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityHistory(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                        minimumSize: Size(265, 55),
                      ),
                      child: Text(
                        "ACTIVITY HISTORY",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1.0),
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityHistory(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                        minimumSize: Size(265, 55),
                      ),
                      child: Text(
                        "TRACK AMBULANCE",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1.0),
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

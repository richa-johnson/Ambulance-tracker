import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/dashbord/patientDetailsForm.dart';
import 'package:ambulance_tracker/dashbord/userEdit.dart';
import 'package:ambulance_tracker/dashbord/userHistory.dart';
import 'package:ambulance_tracker/registration/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class userdashboard extends StatefulWidget {
  const userdashboard({super.key});

  @override
  State<userdashboard> createState() => _userdashboardState();
}

class _userdashboardState extends State<userdashboard> {
  bool hasooked = true;

  String drname = "driver name";
  String phno = "Phone no";
  String vhno = "Vehicle no";
  Future<bool> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      print("No token found");
      return false;
    }
    final response = await http.post(
      Uri.parse(logoutURL),
      headers: {'Authorization': 'Bearer $token', 'accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      await prefs.remove('token');
      await prefs.remove('userId');
      return true;
    } else {
      if (!mounted) return false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Logout Failed")));
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: PopupMenuButton<String>(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Color.fromRGBO(189, 83, 114, 1.0),
                            width: 2,
                          ),
                        ),
                        icon: Icon(
                          Icons.person,
                          size: 30,
                          color: Color.fromRGBO(87, 24, 44, 1.0),
                        ),
                        onSelected: (value) async {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => userEdit(),
                              ),
                            );
                          } else if (value == 'logout') {
                            final success = await _logout(context);
                            if (!mounted) return;
                            if (success) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => LoginPage()),
                                (route) => false,
                              );
                            }
                          }
                        },
                        itemBuilder:
                            (BuildContext context) => <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Color.fromRGBO(87, 24, 44, 1.0),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        color: Color.fromRGBO(87, 24, 44, 1.0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                enabled: false,
                                height: 0,
                                padding: EdgeInsets.zero,
                                child: Divider(
                                  thickness: 1.5,
                                  height: 0,
                                  color: Color.fromRGBO(189, 83, 114, 1.0),
                                  indent: 10,
                                  endIndent: 10,
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'logout',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Color.fromRGBO(87, 24, 44, 1.0),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: Color.fromRGBO(87, 24, 44, 1.0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                              'TAP',
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
                              'TRACK',
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
                              'TRUST',
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

                    SizedBox(height: 20),

                    hasooked
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 351,
                              height: 469,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(137, 131, 131, 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(8),

                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(159, 13, 55, 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Emergency?',
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(
                                                    3,
                                                    3,
                                                  ), // x and y offset
                                                  blurRadius: 2.0,
                                                  color: Colors.black
                                                      .withOpacity(1.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Don\'t panic',
                                            style: TextStyle(
                                              fontSize: 27,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(
                                                    3,
                                                    3,
                                                  ), // x and y offset
                                                  blurRadius: 2.0,
                                                  color: Colors.black
                                                      .withOpacity(1.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Book your ambulance',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(
                                                    3,
                                                    3,
                                                  ), // x and y offset
                                                  blurRadius: 2.0,
                                                  color: Colors.black
                                                      .withOpacity(1.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'instantly!',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(
                                                    3,
                                                    3,
                                                  ), // x and y offset
                                                  blurRadius: 2.0,
                                                  color: Colors.black
                                                      .withOpacity(1.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(1),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: Offset(
                                                    0,
                                                    6,
                                                  ), // changes the position of the shadow
                                                ),
                                              ],
                                            ),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(161, 47),
                                                backgroundColor: Colors.white,
                                                elevation:
                                                    0, // No built-in shadow to avoid mixing
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(35),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>patientDetailsForm()));
                                              },
                                              child: Text(
                                                'BOOK NOW',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w900,
                                                  color: Color.fromRGBO(
                                                    159,
                                                    13,
                                                    55,
                                                    1.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      width: 340,
                                      height: 190,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10),
                                          bottom: Radius.circular(10),
                                        ),
                                        color: Color.fromRGBO(217, 217, 217, 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                            ),
                                            child: Container(
                                              color: Colors.grey,
                                              width: 100,
                                              height: 3,
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              'Your Ambulance is on the way',
                                              style: TextStyle(
                                                color: const Color.fromARGB(
                                                  255,
                                                  0,
                                                  0,
                                                  0,
                                                ),
                                                fontSize: 19,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsetsGeometry.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                  child: Text(
                                                    drname,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsGeometry.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  child: Text(
                                                    phno,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsGeometry.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  child: Text(
                                                    vhno,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
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
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      width: 341,
                                      height: 53,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(143, 130, 130, 1),
                                        borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Text(
                                              'Track Ambulance',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 19,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.arrow_forward),
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 351,
                              height: 348,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(137, 131, 131, 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(159, 13, 55, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Emergency?',
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(
                                                3,
                                                3,
                                              ), // x and y offset
                                              blurRadius: 2.0,
                                              color: Colors.black.withOpacity(
                                                1.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Don\'t panic',
                                        style: TextStyle(
                                          fontSize: 27,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(
                                                3,
                                                3,
                                              ), // x and y offset
                                              blurRadius: 2.0,
                                              color: Colors.black.withOpacity(
                                                1.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Text(
                                        'Book your ambulance',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(
                                                3,
                                                3,
                                              ), // x and y offset
                                              blurRadius: 2.0,
                                              color: Colors.black.withOpacity(
                                                1.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'instantly!',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(
                                                3,
                                                3,
                                              ), // x and y offset
                                              blurRadius: 2.0,
                                              color: Colors.black.withOpacity(
                                                1.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),

                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            35,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                1,
                                              ),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: Offset(
                                                0,
                                                6,
                                              ), // changes the position of the shadow
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(161, 47),
                                            backgroundColor: Colors.white,
                                            elevation:
                                                0, // No built-in shadow to avoid mixing
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>patientDetailsForm()));
                                          },
                                          child: Text(
                                            'BOOK NOW',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w900,
                                              color: Color.fromRGBO(
                                                159,
                                                13,
                                                55,
                                                1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 28),
                            Container(
                              width: 361,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(143, 130, 130, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      'See Booking History',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHistory()));
                                    },
                                    icon: Icon(Icons.arrow_forward),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
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

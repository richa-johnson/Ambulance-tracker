import 'dart:convert';
import 'package:ambulance_tracker/alerts/requestpage.dart';
import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/controller/driver_booking_controller.dart';
import 'package:ambulance_tracker/controller/location_controller.dart';
import 'package:ambulance_tracker/dashbord/driverEdit.dart';
import 'package:ambulance_tracker/dashbord/driverHistory.dart';
import 'package:ambulance_tracker/location/Trackpatient.dart';
import 'package:ambulance_tracker/registration/login.dart';
import 'package:ambulance_tracker/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class driverDashboard extends StatefulWidget {
  const driverDashboard({super.key});

  @override
  State<driverDashboard> createState() => _driverDashboardState();
}

class _driverDashboardState extends State<driverDashboard> {
  String bookedby = "ravi",
      phoneno = "7736798040",
      noPatients = '1',
      pname = "harsha",
      age = "7",
      bloodGroup = "B+",
      location = "snadkugfheanjzxd",
      date = "77-36-7980",
      time = "77:36:79";

  bool onRun = false;
  bool isAvailable = false;
  final DriverBookingController bookingCtrl = Get.find();
  final LocationController locationController = Get.put(LocationController());

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
      if (Get.isRegistered<DriverBookingController>()) {
        final ctrl = Get.find<DriverBookingController>();
        ctrl.stopPolling(); // Stop background task
        Get.delete<DriverBookingController>(force: true);
      }

      return true;
    } else {
      if (!mounted) return false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Logout Failed")));
      return false;
    }
  }
  
  Future<void> updateDriverStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      print("No token found");
      return;
    }
    final Uri url = Uri.parse(driverStatusURL);
    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'status': status}),
      );
      if (response.statusCode == 200) {
        print('Status updated to $status');
      } else {
        print('Failed to update status: ${response.body}');
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => LocationService.instance.startTracking(
        controller: locationController,
        context: context,
      ),
    );
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
        child:SingleChildScrollView(
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
                                builder: (context) => DriverEdit(),
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
                          } else if (value == 'requestPage') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestsPage(),
                              ),
                            );
                          } else if ( value == 'driveractivity') {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverHistory()));
                          }
                        },
                        itemBuilder:
                            (BuildContext context) => <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
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
                                value: 'requestPage',
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Text(
                                      'User Requests',
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
                                value: 'driveractivity',
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Text(
                                      'Activity History',
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.3,
                            ), // shadow color
                            blurRadius: 10, // soft blur
                            offset: Offset(0, 6), // x, y offset
                            spreadRadius: 1, // how far it spreads
                          ),
                        ],
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
                              'ALERT',
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
                              'ARRIVE',
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
                              'ASSIST',
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

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: 342,
                      height: 116,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(217, 217, 217, 1),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.5,
                            ), // shadow color
                            blurRadius: 10, // soft blur
                            offset: Offset(0, 3), // x, y offset
                            spreadRadius: 1, // how far it spreads
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'ARE YOU AVAILABLE TO WORK?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: 317,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Stack(
                              children: [
                                AnimatedAlign(
                                  alignment:
                                      isAvailable
                                          ? Alignment.centerLeft
                                          : Alignment.centerRight,
                                  curve: Curves.easeInOut,
                                  duration: Duration(microseconds: 300),
                                  child: Container(
                                    width: 158.5,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(159, 13, 55, 1.0),
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isAvailable = true;
                                          });
                                          updateDriverStatus('available');
                                        },
                                        child: Center(
                                          child: Text(
                                            'AVAILABLE',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  isAvailable
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap:
                                            () => {
                                              setState(() {
                                                isAvailable = false;
                                              }),
                                              updateDriverStatus('unavailable'),
                                            },
                                        child: Center(
                                          child: Text(
                                            'UNAVAILABLE',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  !isAvailable
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                          ),
                                        ),
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

                    SizedBox(height: 12),

                    Stack(
                      children: [
                        Container(
                          height: 333,
                          width: 340,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(217, 217, 217, 1),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child:
                              onRun
                                  ? Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                            ),
                                            child: Text(
                                              'Hurry...Your patient is waiting',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 19,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: SizedBox(
                                              height: 235,
                                              width: 300,
                                              child: Card(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(15),
                                                  child: SingleChildScrollView(
                                                    child: Table(
                                                      columnWidths: {
                                                        0: IntrinsicColumnWidth(),
                                                        1: FixedColumnWidth(10),
                                                        2: FlexColumnWidth(),
                                                      },
                                                      children: [
                                                        HistoryTable(
                                                          label: "Booked by",
                                                          value: bookedby,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Phone no",
                                                          value: phoneno,
                                                        ).build(),
                                                        HistoryTable(
                                                          label:
                                                              "Number of Patients",
                                                          value: noPatients,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Patient Name",
                                                          value: pname,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Age",
                                                          value: age,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Blood Group",
                                                          value: bloodGroup,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Location",
                                                          value: location,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Date",
                                                          value: date,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Time",
                                                          value: time,
                                                        ).build(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 53,
                                          ), // reserve space for bottom container
                                        ],
                                      ),

                                      // Align the bottom container to the bottom
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 53,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                              143,
                                              130,
                                              130,
                                              1,
                                            ),
                                            borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Text(
                                                  'Track Patient',
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
                                  )
                                  : Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                            ),
                                            child: Text(
                                              'YOUR LAST ACTIVITY',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 19,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: SizedBox(
                                              height: 235,
                                              width: 300,
                                              child: Card(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(15),
                                                  child: SingleChildScrollView(
                                                    child: Table(
                                                      columnWidths: {
                                                        0: IntrinsicColumnWidth(),
                                                        1: FixedColumnWidth(10),
                                                        2: FlexColumnWidth(),
                                                      },
                                                      children: [
                                                        HistoryTable(
                                                          label: "Booked by",
                                                          value: bookedby,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Phone no",
                                                          value: phoneno,
                                                        ).build(),
                                                        HistoryTable(
                                                          label:
                                                              "Number of Patients",
                                                          value: noPatients,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Patient Name",
                                                          value: pname,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Age",
                                                          value: age,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Blood Group",
                                                          value: bloodGroup,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Location",
                                                          value: location,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Date",
                                                          value: date,
                                                        ).build(),
                                                        HistoryTable(
                                                          label: "Time",
                                                          value: time,
                                                        ).build(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 53,
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 53,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                              143,
                                              130,
                                              130,
                                              1,
                                            ),
                                            borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Text(
                                                  'Track Patient',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 19,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              Trackpatient(),
                                                    ),
                                                  );
                                                },
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}

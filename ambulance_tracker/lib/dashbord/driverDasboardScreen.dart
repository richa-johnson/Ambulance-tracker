// ignore_for_file: deprecated_member_use

import 'package:ambulance_tracker/dashbord/driverHistory.dart';
import 'package:ambulance_tracker/dashbord/userHistory.dart';
import 'package:flutter/material.dart';

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

  String drname = "driver name";
  String phno = "Phone no";
  String vhno = "Vehicle no";

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
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.person),
                        iconSize: 30,
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
                                                        ActivityHistoryTable(
                                                          label: "Booked by",
                                                          value: bookedby,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label: "Phone no",
                                                          value: phoneno,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label:
                                                              "Number of Patients",
                                                          value: noPatients,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label: "Patient Name",
                                                          value: pname,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label: "Age",
                                                          value: age,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label: "Blood Group",
                                                          value: bloodGroup,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label: "Location",
                                                          value: location,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label: "Date",
                                                          value: date,
                                                        ).build(),
                                                        ActivityHistoryTable(
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
                                                        ActivityHistoryTable(
                                                          label: "Booked by",
                                                          value: bookedby,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label: "Phone no",
                                                          value: phoneno,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label:
                                                              "Number of Patients",
                                                          value: noPatients,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label: "Patient Name",
                                                          value: pname,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label: "Age",
                                                          value: age,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label: "Blood Group",
                                                          value: bloodGroup,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label: "Location",
                                                          value: location,
                                                        ).build(),
                                                        ActivityHistoryTable(
                                                          label: "Date",
                                                          value: date,
                                                        ).build(),
                                                        ActivityHistoryTable(
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
                                                  'Activity history',
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

// import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';

import 'package:flutter/material.dart';

class Trackambulancescreen extends StatefulWidget {
  const Trackambulancescreen({super.key});

  @override
  State<Trackambulancescreen> createState() => _TrackambulancescreenState();
}

class _TrackambulancescreenState extends State<Trackambulancescreen> {
  String dname = 'Driver Name';
  String phoneno = "Phone  number";
  String vehno = "Vehicle no";
  String sector = "Sector";

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
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),

          child: Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Container(
              width: 323,
              height: 805,

              decoration: BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.all(8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                        Expanded(
                          child: Text(
                            'Your ambulance is on the way',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  height: 137,
                                  width: 341,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
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
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                          horizontal: 10,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dname,
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            Text(
                                              phoneno,
                                              style: TextStyle(fontSize: 18),
                                            ),

                                            Text(
                                              vehno,
                                              style: TextStyle(fontSize: 16),
                                            ),

                                            Text(
                                              sector,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 53,
                                  width: 341,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(143, 130, 130, 1),
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(10),
                                    ),
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
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
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                           Center(
                            child: Column(
                              children: [
                                Container(
                                  height: 137,
                                  width: 341,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
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
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                          horizontal: 10,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dname,
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            Text(
                                              phoneno,
                                              style: TextStyle(fontSize: 18),
                                            ),

                                            Text(
                                              vehno,
                                              style: TextStyle(fontSize: 16),
                                            ),

                                            Text(
                                              sector,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 53,
                                  width: 341,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(143, 130, 130, 1),
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(10),
                                    ),
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
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
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                           Center(
                            child: Column(
                              children: [
                                Container(
                                  height: 137,
                                  width: 341,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
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
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                          horizontal: 10,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dname,
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            Text(
                                              phoneno,
                                              style: TextStyle(fontSize: 18),
                                            ),

                                            Text(
                                              vehno,
                                              style: TextStyle(fontSize: 16),
                                            ),

                                            Text(
                                              sector,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 53,
                                  width: 341,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(143, 130, 130, 1),
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(10),
                                    ),
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
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
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                           Center(
                            child: Column(
                              children: [
                                Container(
                                  height: 137,
                                  width: 341,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
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
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                          horizontal: 10,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dname,
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            Text(
                                              phoneno,
                                              style: TextStyle(fontSize: 18),
                                            ),

                                            Text(
                                              vehno,
                                              style: TextStyle(fontSize: 16),
                                            ),

                                            Text(
                                              sector,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 53,
                                  width: 341,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(143, 130, 130, 1),
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(10),
                                    ),
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
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
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                           Center(
                            child: Column(
                              children: [
                                Container(
                                  height: 137,
                                  width: 341,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
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
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                          horizontal: 10,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dname,
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            Text(
                                              phoneno,
                                              style: TextStyle(fontSize: 18),
                                            ),

                                            Text(
                                              vehno,
                                              style: TextStyle(fontSize: 16),
                                            ),

                                            Text(
                                              sector,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 53,
                                  width: 341,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(143, 130, 130, 1),
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(10),
                                    ),
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
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
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

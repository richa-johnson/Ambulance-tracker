// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class userdashboard extends StatefulWidget {
  const userdashboard({super.key});

  @override
  State<userdashboard> createState() => _userdashboardState();
}

class _userdashboardState extends State<userdashboard> {
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

                    Container(
                      width: 344,
                      height: 364,

                      decoration: BoxDecoration(
                        color: Color.fromRGBO(159, 13, 55, 1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromRGBO(137, 131, 131, .5),
                          width: 5,
                        ),
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
                                    offset: Offset(3, 3), // x and y offset
                                    blurRadius: 2.0,
                                    color: Colors.black.withOpacity(1.0),
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
                                    offset: Offset(3, 3), // x and y offset
                                    blurRadius: 2.0,
                                    color: Colors.black.withOpacity(1.0),
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
                                    offset: Offset(3, 3), // x and y offset
                                    blurRadius: 2.0,
                                    color: Colors.black.withOpacity(1.0),
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
                                    offset: Offset(3, 3), // x and y offset
                                    blurRadius: 2.0,
                                    color: Colors.black.withOpacity(1.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),

                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(1),
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
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                ),
                                onPressed: () {},

                                child: Text(
                                  'BOOK NOW',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Color.fromRGBO(159, 13, 55, 1.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          Container(
                            padding:EdgeInsets.symmetric(horizontal: 10),
                            child: Text('See Booking History',
                            style: TextStyle(
                              
                              color: Colors.white,
                              fontSize: 19,
                            
                            ),),
                          ),
                          IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward),
                          color: Colors.white,
                          )
                        ],
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

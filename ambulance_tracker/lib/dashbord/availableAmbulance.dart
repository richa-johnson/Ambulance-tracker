import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/dashbord/patientDetailsForm.dart';
import 'package:ambulance_tracker/dashbord/driverDetails.dart';
import 'package:ambulance_tracker/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AvailableAmbulance extends StatefulWidget {
  const AvailableAmbulance({super.key});

  @override
  State<AvailableAmbulance> createState() => AvailableAmbulanceState();
}

class AvailableAmbulanceState extends State<AvailableAmbulance> {
  bool isPressed = false;
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  void _loadUserDetails() async {
    final response = await getUserDetail();
    if (response.error == null) {
      final data = response.data as Map<String, dynamic>;

      // Extract the nested 'user' object
      final user = data['user'] as Map<String, dynamic>;

      print("Signed-in User Details:");
      print("ID       : ${user['id']}");
      print("Name     : ${user['name']}");
      print("Phone No : ${user['phone_no']}");
      print("District : ${user['district']}");
      print("Email    : ${user['mail']}");

      // Optional: You can store in variables if needed
      // String name = user['user_name'];
      // String phone = user['user_phone'];
      // etc.
    } else {
      print("Failed to fetch user details: ${response.error}");
    }
  }

  Future<List<DriverModel>> fetchDrivers() async {
    final response = await http.get(Uri.parse(getAvailabledriversURL));
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      return jsonData.map((e) => DriverModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load drivers");
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
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Container(
                  height: 76,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(227, 185, 197, 1),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                      bottom: Radius.circular(0),
                    ),
                  ),
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => patientDetailsForm(),
                              ),
                            );
                          },
                          icon: Icon(Icons.arrow_back),
                          iconSize: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(107),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Sort button
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.near_me),
                                      title: Text("Sort by Nearest"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        // Handle sorting logic here
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.timer),
                                      title: Text("Sort by Availability"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        // Handle sorting logic here
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.sort, size: 18, color: Colors.black),
                                SizedBox(width: 6),
                                Text(
                                  "Sort",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Divider
                      Container(width: 1, height: 30, color: Colors.grey[300]),

                      // Filter button
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (context) {
                                List<String> facilities = [
                                  "Oxygen",
                                  "ICU",
                                  "Ventilator",
                                ];
                                List<String> selected = [];

                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Select Facilities",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          ...facilities.map((facility) {
                                            return CheckboxListTile(
                                              title: Text(facility),
                                              value: selected.contains(
                                                facility,
                                              ),
                                              onChanged: (bool? val) {
                                                setState(() {
                                                  if (val == true) {
                                                    selected.add(facility);
                                                  } else {
                                                    selected.remove(facility);
                                                  }
                                                });
                                              },
                                            );
                                          }),
                                          ElevatedButton(
                                            child: Text("Apply Filter"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              // Handle filtering with selected list
                                              print(
                                                "Selected filters: $selected",
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.filter_list,
                                  size: 18,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Filter",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder<List<DriverModel>>(
                  future: fetchDrivers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else {
                      final drivers = snapshot.data!;
                      return Column(
                        children:
                            drivers
                                .map((driver) => CustomCard(driver: driver))
                                .toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  final DriverModel driver;

  const CustomCard({super.key, required this.driver});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ), // Fixed: .circular instead of Geometry
        ),
        color: Color.fromRGBO(159, 13, 55, 1.0),
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Replaced ListTile with Padding + Text for better spacing control
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8, left: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.driver.name,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 15),
                      Icon(Icons.phone, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        widget.driver.phoneno,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 25),
                      Text(
                        widget.driver.vehicleno,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(width: 110),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPressed ? Colors.green : Colors.white,
                      minimumSize: Size(81, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      isPressed ? "Request Sent" : "Book Now",
                      style: TextStyle(
                        color:
                            isPressed
                                ? Colors.white
                                : Color.fromRGBO(159, 13, 55, 1.0),
                        fontSize: 10,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isPressed = !isPressed;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              height: 1,
              color: Color.fromRGBO(231, 164, 164, 1.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 3,
                                    color: const Color.fromARGB(
                                      115,
                                      110,
                                      108,
                                      108,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    widget.driver.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(159, 13, 55, 1.0),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        double
                                            .infinity, // Makes it use full available width
                                    alignment:
                                        Alignment
                                            .centerLeft, // Aligns the column to the left
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ), // Optional horizontal padding
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 4),
                                        Text(
                                          "Sector: ${widget.driver.sector}",
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                              159,
                                              13,
                                              55,
                                              1.0,
                                            ),
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Facilities",
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                              159,
                                              13,
                                              55,
                                              1.0,
                                            ),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Capacity: ${widget.driver.capacity}",
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                              159,
                                              13,
                                              55,
                                              1.0,
                                            ),
                                            fontSize: 18,
                                          ),
                                        ),
                                        ...widget.driver.facilities.map(
                                          (facility) => Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 2,
                                            ),
                                            child: Text(
                                              "• $facility",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                  159,
                                                  13,
                                                  55,
                                                  1.0,
                                                ),
                                                fontSize: 18,
                                              ),
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
                      },
                    );
                  },

                  child: Text(
                    "View More",
                    style: TextStyle(color: Color.fromRGBO(231, 164, 164, 1.0)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

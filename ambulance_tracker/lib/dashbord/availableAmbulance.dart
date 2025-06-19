import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/dashbord/patientDetailsForm.dart';
import 'package:ambulance_tracker/dashbord/driverDetails.dart';
import 'package:ambulance_tracker/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ambulance_tracker/models/driver_model.dart';

class AvailableAmbulance extends StatefulWidget {
  const AvailableAmbulance({super.key});
final String pickupLocation;
  final int    patientCount;
  final List<Map<String, dynamic>> patientList;

  const AvailableAmbulance({
    Key? key,
    required this.pickupLocation,
    required this.patientCount,
    required this.patientList,
  }) 
  
  @override
  State<AvailableAmbulance> createState() => AvailableAmbulanceState();
}

class AvailableAmbulanceState extends State<AvailableAmbulance> {
  bool isPressed = false;
  

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
                                .map((driver) => CustomCard(driver: driver,pickupLocation: ,))
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
  final String pickupLocation;
  final int patientCount;
  final List<Map<String, dynamic>> patientList;

  const CustomCard({
    super.key,
    required this.driver,
    required this.pickupLocation,
    required this.patientCount,
    required this.patientList,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isPressed = false;

  // ------------------------- API helpers ------------------------------------
  Future<int> _createBooking({
    required String token,
  }) async {
    final res = await http.post(
      Uri.parse('$baseURL/booking'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'driver_id': widget.driver.id,
        'p_location': widget.pickupLocation,
        'p_count':    widget.patientCount,
      }),
    );
    if (res.statusCode == 201) {
      return (jsonDecode(res.body)['booking_id']) as int;
    }
    throw Exception('Booking failed: ${res.body}');
  }

  Future<void> _sendPatients({
    required String token,
    required int bookingId,
  }) async {
    final res = await http.post(
      Uri.parse('$baseURL/booking/$bookingId/patients'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'patients': widget.patientList}),
    );
    if (res.statusCode != 204) {
      throw Exception('Patients upload failed: ${res.body}');
    }
  }

  Future<void> _bookDriver() async {
    try {
      final token = await getToken();   // TODO: implement this helper
      final id    = await _createBooking(token: token);
      await _sendPatients(token: token, bookingId: id);

      setState(() => isPressed = true);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Request sent!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  // -------------------------- UI -------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      color: const Color(0xFF9F0D37),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.driver.name,
                style: const TextStyle(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(widget.driver.phoneno,
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isPressed ? Colors.green : Colors.white,
              ),
              onPressed: isPressed ? null : _bookDriver,
              child: Text(
                isPressed ? 'Request Sent' : 'Book Now',
                style: TextStyle(
                  color: isPressed
                      ? Colors.white
                      : const Color(0xFF9F0D37),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

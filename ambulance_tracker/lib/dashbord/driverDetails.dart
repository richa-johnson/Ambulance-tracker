import 'dart:convert';

import 'package:ambulance_tracker/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DriverDetails extends StatefulWidget {
  const DriverDetails({super.key});

  @override
  State<DriverDetails> createState() => _DriverDetailsState();
}

class _DriverDetailsState extends State<DriverDetails> {
  List<DriverModel> DriverList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchdrivers();
  }

  Future<void> fetchdrivers() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("No token found. Please login.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await http.get(
      Uri.parse(getDriverURL),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data =
          decoded is List ? decoded : (decoded['data'] ?? []);

      setState(() {
        DriverList = data.map((json) => DriverModel.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      print("Failed to load users: ${response.body}");
      setState(() {
        isLoading = false;
      });
    }
  } catch (e) {
    print("Error fetching drivers: $e");
    setState(() {
      isLoading = false;
    });
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
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
              children: [
                SizedBox(height: 20),
                Text("DRIVER DETAILS", textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(87, 24, 44,1), fontWeight: FontWeight.bold,fontSize: 32),),
                SizedBox(height: 20),
                  Expanded(
                    child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Table(
                            defaultColumnWidth: IntrinsicColumnWidth(),
                            border: TableBorder.all(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              width: 1.0,
                              style: BorderStyle.solid
                            ),
                            children: [
                              DriverDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ", vehicleno: "Vehicle No", capacity: "Capacity", sector: "Sector", facilities: "Facilities", license: "License").build(),
                              for (var driver in DriverList)
                                DriverDetailsTable(slno: driver.slno, name: driver.name, phoneno: driver.phoneno, emailid: driver.emailid, district: driver.district, vehicleno: driver.vehicleno, capacity: driver.capacity, sector: driver.sector, facilities: driver.facilities.join(', '), license: driver.license).build(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
  }
}

class DriverDetailsTable{
  final String slno;
  final String name;
  final String phoneno;
  final String emailid;
  final String district;
  final String vehicleno;
  final String capacity;
  final String facilities;
  final String sector;
  final String license;
 
  DriverDetailsTable({required this.slno,required this.name,required this.phoneno,required this.emailid,required this.district,required this.vehicleno,required this.capacity,required this.sector,required this.facilities,required this.license});

  TableRow build() {
  TextStyle textStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w900,
    fontSize: 17,
  );

    return TableRow(
      children: [
        tableCell(slno, textStyle),
        tableCell(name, textStyle),
        tableCell(phoneno, textStyle),
        tableCell(emailid, textStyle),
        tableCell(district, textStyle),
        tableCell(vehicleno, textStyle),
        tableCell(capacity, textStyle),
        tableCell(sector, textStyle),
        tableCell(facilities, textStyle),
        tableCell(license, textStyle),
      ],
    );
  }

  Widget tableCell(String content, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        content,
        style: style,
        overflow: TextOverflow.visible,
        softWrap: false,
      ),
    );
  }
}

class DriverModel {
  final String slno;
  final String name;
  final String phoneno;
  final String emailid;
  final String district;
  final String vehicleno;
  final String capacity;
  final List<String> facilities;
  final String sector;
  final String license;

  DriverModel({
    required this.slno,
    required this.name,
    required this.phoneno,
    required this.emailid,
    required this.district,
    required this.vehicleno,required this.capacity,required this.sector,required this.facilities,required this.license
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
  return DriverModel(
    slno: json['slno'].toString(),
    name: json['name'] ?? '',
    phoneno: json['phoneno'] ?? '',
    emailid: json['emailid'] ?? '',
    district: json['district'] ?? '',
    vehicleno: json['vehicleno'] ?? '',
    capacity: json['capacity'] ?? '',
    sector: json['sector'] ?? '',
    facilities: List<String>.from(json['facilities'] ?? []),
    license: json['license'] ?? ''
  );
}

  get id => null;

}

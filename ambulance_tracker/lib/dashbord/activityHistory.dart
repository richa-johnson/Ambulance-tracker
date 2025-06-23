import 'dart:convert';
import 'package:ambulance_tracker/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; // Adjust path if needed

class ActivityHistory extends StatefulWidget {
  const ActivityHistory({super.key});

  @override
  State<ActivityHistory> createState() => _ActivityHistoryState();
}

class _ActivityHistoryState extends State<ActivityHistory> {
  List<ActivityRecord> records = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchActivityHistory();
  }

  Future<void> fetchActivityHistory() async {
    final url = Uri.parse('$baseURL/booking/activity-history');

    try {
  final response = await http.get(url);

  print("Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    setState(() {
      records = data.map((e) => ActivityRecord.fromJson(e)).toList();
      isLoading = false;
    });
  } else {
    throw Exception("Failed to load history");
  }
} catch (e) {
  print("Error: $e");
  setState(() => isLoading = false);
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
              Text(
                "ACTIVITY HISTORY",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(87, 24, 44, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child:
                          isLoading
                              ? Center(child: CircularProgressIndicator())
                              : Table(
                                defaultColumnWidth: IntrinsicColumnWidth(),
                                border: TableBorder.all(color: Colors.black),
                                children: [
                                  ActivityHistoryTable(
                                    slno: "Sl No",
                                    uname: "User Name",
                                    uphoneno: "User Phone No",
                                    dname: "Driver Name",
                                    dphoneno: "Driver Phone No",
                                    vehicleno: "Vehicle No",
                                    pcount: "Patient count",
                                    location: "Location",
                                    timestamp: "Timestamp",
                                  ).build(),
                                  for (var record in records)
                                    ActivityHistoryTable(
                                      slno: record.slno,
                                      uname: record.uname,
                                      uphoneno: record.uphoneno,
                                      dname: record.dname,
                                      dphoneno: record.dphoneno,
                                      vehicleno: record.vehicleno,
                                      pcount: record.pcount,
                                      location: record.location,
                                      timestamp: record.timestamp,
                                    ).build(),
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

class ActivityHistoryTable {
  final String slno;
  final String uname;
  final String uphoneno;
  final String dname;
  final String dphoneno;
  final String vehicleno;
  final String pcount;
  final String location;
  final String timestamp;

  ActivityHistoryTable({
    required this.slno,
    required this.uname,
    required this.uphoneno,
    required this.dname,
    required this.dphoneno,
    required this.vehicleno,
    required this.pcount,
    required this.location,
    required this.timestamp,
  });

  TableRow build() {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w900,
      fontSize: 17,
    );

    return TableRow(
      children: [
        tableCell(slno, textStyle),
        tableCell(uname, textStyle),
        tableCell(uphoneno, textStyle),
        tableCell(dname, textStyle),
        tableCell(dphoneno, textStyle),
        tableCell(vehicleno, textStyle),
        tableCell(pcount, textStyle),
        tableCell(location, textStyle),
        tableCell(timestamp, textStyle),
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

class ActivityRecord {
  final String slno;
  final String uname;
  final String uphoneno;
  final String dname;
  final String dphoneno;
  final String vehicleno;
  final String pcount;
  final String location;
  final String timestamp;

  ActivityRecord({
    required this.slno,
    required this.uname,
    required this.uphoneno,
    required this.dname,
    required this.dphoneno,
    required this.vehicleno,
    required this.pcount,
    required this.location,
    required this.timestamp,
  });

  factory ActivityRecord.fromJson(Map<String, dynamic> json) {
    return ActivityRecord(
      slno: json['slno'].toString(),
      uname: json['uname'],
      uphoneno: json['uphoneno'],
      dname: json['dname'],
      dphoneno: json['dphoneno'],
      vehicleno: json['vehicleno'],
      pcount: json['pcount'].toString(),
      location: json['location'],
      timestamp: json['timestamp'],
    );
  }
}

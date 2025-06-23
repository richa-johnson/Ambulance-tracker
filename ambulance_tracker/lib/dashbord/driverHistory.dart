import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ambulance_tracker/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverHistory extends StatefulWidget {
  const DriverHistory({super.key});

  @override
  State<DriverHistory> createState() => _DriverHistoryState();
}

class _DriverHistoryState extends State<DriverHistory> {
  List<Map<String, String>> historyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDriverHistory();
  }

  Future<void> fetchDriverHistory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null || token.isEmpty) {
    print("⚠️ Token not found. User may not be logged in.");
    setState(() => isLoading = false);
    return;
  }

  final response = await http.get(
    Uri.parse('$baseURL/booking/driver-history'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    setState(() {
      historyList = data.map<Map<String, String>>((item) => {
            'uname': item['uname'] ?? 'N/A',
            'phoneno': item['phoneno'] ?? 'N/A',
            'pcount': item['pcount'].toString(),
            'location': item['location'] ?? 'N/A',
            'timestamp': item['timestamp'] ?? 'N/A',
          }).toList();
      isLoading = false;
    });
  } else {
    print("❌ Failed to load driver history. Status code: ${response.statusCode}");
    print("Response body: ${response.body}");
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
          padding: EdgeInsets.only(top: 10, right: 10, left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Container(
            padding: EdgeInsets.only(top: 30, right: 10, left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(156, 150, 150, 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "YOUR ACTIVITY HISTORY",
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                          children:
                              historyList
                                  .map(
                                    (entry) => Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: SizedBox(
                                        height: 200,
                                        width: 350,
                                        child: Card(
                                          color: Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            1,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Table(
                                              columnWidths: {
                                                0: IntrinsicColumnWidth(),
                                                1: FixedColumnWidth(10),
                                                2: FlexColumnWidth(),
                                              },
                                              children: [
                                                HistoryTable(
                                                  label: "Booked by",
                                                  value: entry['uname']!,
                                                ).build(),
                                                HistoryTable(
                                                  label: "Phone No",
                                                  value: entry['phoneno']!,
                                                ).build(),
                                                HistoryTable(
                                                  label: "No of Patients",
                                                  value: entry['pcount']!,
                                                ).build(),
                                                HistoryTable(
                                                  label: "Location",
                                                  value: entry['location']!,
                                                ).build(),
                                                HistoryTable(
                                                  label: "Time Stamp",
                                                  value: entry['timestamp']!,
                                                ).build(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryTable {
  final String label;
  final String seperator;
  final String value;

  HistoryTable({
    required this.label,
    this.seperator = ":",
    required this.value,
  });

  TableRow build() {
    return TableRow(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
        Text(
          seperator,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}

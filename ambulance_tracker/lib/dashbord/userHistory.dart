import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/dashbord/driverHistory.dart';
import 'package:ambulance_tracker/services/user_services.dart';
import 'package:flutter/material.dart';

class UserHistory extends StatefulWidget {
  const UserHistory({super.key});

  @override
  State<UserHistory> createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
  List<dynamic> historyList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchUserHistory();
  }

  Future<void> fetchUserHistory() async {
    String token = await getToken();

    final response = await http.get(
      Uri.parse('$baseURL/booking/user-history'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        historyList = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      debugPrint(
        '❌ Failed to load user history. Status code: ${response.statusCode}',
      );
      debugPrint('Response body: ${response.body}');
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
                    "YOUR BOOKING HISTORY",
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child:
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : historyList.isEmpty
                          ? Center(child: Text("No history found"))
                          : SingleChildScrollView(
                            child: Column(
                              children:
                                  historyList.map((item) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: SizedBox(
                                        height: 200,
                                        width: 350,
                                        child: Card(
                                          color: Colors.white,
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
                                                  label: "Driver Name",
                                                  value: item['dname'],
                                                ).build(),
                                                HistoryTable(
                                                  label: "Phone No",
                                                  value: item['phoneno'],
                                                ).build(),
                                                HistoryTable(
                                                  label: "Vehicle No",
                                                  value: item['vehicleNo'],
                                                ).build(),
                                                HistoryTable(
                                                  label: "Location",
                                                  value: item['location'],
                                                ).build(),
                                                HistoryTable(
                                                  label: "Time Stamp",
                                                  value:
                                                      item['timestamp']
                                                          .toString(),
                                                ).build(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
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

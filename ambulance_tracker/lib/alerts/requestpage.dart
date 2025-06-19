import 'package:ambulance_tracker/location/location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => RequestsPageState();
}

class RequestsPageState extends State<RequestsPage> {
  String userName = "Rajesh";
  int ph = 9432456107;
  int no = 3;
  String blood = "O +ve";
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
            child: Column(children: [CustomRequests(), CustomRequests()]),
          ),
        ),
      ),
    );
  }
}

class CustomRequests extends StatefulWidget {
  const CustomRequests({super.key});

  @override
  State<CustomRequests> createState() => _CustomRequestsState();
}

class _CustomRequestsState extends State<CustomRequests> {
  String userName = "Rajesh";
  String ph = '9432456107';
  String no = '3';
  String blood = "O +ve";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        shape: BeveledRectangleBorder(borderRadius: BorderRadiusGeometry.zero),
        color: Colors.white,
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 15),
                      Text(
                        userName,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 75),
                  Icon(Icons.phone, color: const Color.fromARGB(255, 8, 8, 8)),
                  SizedBox(width: 5),
                  Text(
                    ph,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 1, 1, 1),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 15),
                      Text(
                        "No of Patients: $no",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 13, 13, 13),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 75),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoutingPage(),
                            ),
                          );
                        },
                        child: Text("Confirm"),
                      ),
                    ],
                  ),
                  SizedBox(width: 75),
                  TextButton(onPressed: RequestsPage.new, child: Text("Deny")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:ambulance_tracker/alerts/confirmalert.dart';
import 'package:ambulance_tracker/alerts/deniedalert.dart';
import 'package:flutter/material.dart';

class RequestAlert extends StatefulWidget {
  const RequestAlert({super.key});

  @override
  State<RequestAlert> createState() => RequestAlertState();
}

class RequestAlertState extends State<RequestAlert> {
  String name = "Reyan";
  int ph = 9432456107;
  int no = 3;
  String blood = "O +ve";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text(
                  "Ambulance Requested",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                content: Text(
                  "Booked by: $name \n Contact: $ph\n No.of patients: $no\n Blood Group: $blood",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConfirmAlert()),
                      );
                    },
                    child: Text(
                      "Confirm",
                      style: TextStyle(color: Color.fromRGBO(159, 13, 55, 1.0)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DeniedAlert()),
                      );
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Color.fromRGBO(159, 13, 55, 1.0)),
                    ),
                  ),
                ],
              ),
        );
      });
    });
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

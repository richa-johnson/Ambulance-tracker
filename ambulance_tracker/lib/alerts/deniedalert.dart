import 'package:flutter/material.dart';

class DeniedAlert extends StatefulWidget {
  const DeniedAlert({super.key});

  @override
  State<DeniedAlert> createState() => DeniedAlertState();
}

class DeniedAlertState extends State<DeniedAlert> {
  String name = "Reyan";
  int ph = 9432456107;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(
                "Ambulance Denied!",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              content: Text(
                "Sorry your request was denied. Sent another Request.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Color.fromRGBO(159, 13, 55, 1.0)),
                  ),
                ),
              ],
            ),
      );
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

import 'package:ambulance_tracker/dashbord/availableAmbulance.dart';
import 'package:ambulance_tracker/registration/basic.dart';
import 'package:flutter/material.dart';
import 'package:ambulance_tracker/registration/userRegistration.dart';
import 'package:flutter/services.dart';

class patientDetailsForm extends StatefulWidget {
  const patientDetailsForm({super.key});

  @override
  State<patientDetailsForm> createState() => _patientDetailsFormState();
}

class _patientDetailsFormState extends State<patientDetailsForm> {
  final TextEditingController pnamecontroller = TextEditingController();
  List<String> bloodGroup = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
  String? selectedDistrict;
   final txtEmail    = TextEditingController();
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
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
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
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.person),
                        iconSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "PATIENT DETAILS",
                    style: TextStyle(
                      color: Color.fromRGBO(87, 24, 44, 1),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomInputFieldNumber(hintText: 'NUMBER OF PATIENTS'),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 40, top: 30),
                      child: Text(
                        "ADD PATIENT DETAILS",
                        style: TextStyle(
                          color: Color.fromRGBO(87, 24, 44, 1.0),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomInputField(
                    hintText: 'NAME',
                    controller: pnamecontroller,
                  ),
                  const SizedBox(height: 20),
                  CustomInputFieldNumber(hintText: 'AGE'),
                  const SizedBox(height: 20),
                  Container(
                    width: 325,
                    height: 66,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(227, 185, 197, 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedDistrict,
                        hint: Padding(
                          padding: const EdgeInsets.only(left: 19),
                          child: Text("BLOOD GROUP"),
                        ),
                        items:
                            bloodGroup.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 19),
                                  child: Text(item),
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDistrict = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(left: 32),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => homepage()),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        label: Text(
                          "ADD",
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1.0),
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(187, 51, 90, 1),
                          minimumSize: Size(62, 32),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(left: 32),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => homepage()),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        label: Text(
                          "ADD LOCATION",
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1.0),
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(187, 51, 90, 1),
                          minimumSize: Size(167, 42),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AvailableAmbulance(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                      minimumSize: Size(265, 55),
                    ),
                    child: Text(
                      "VIEW AMBULANCE",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomInputFieldNumber extends StatelessWidget {
  final String hintText;
  const CustomInputFieldNumber({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325,
      height: 66,
      decoration: BoxDecoration(
        color: Color.fromRGBO(227, 185, 197, 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(0, 0, 0, 42),
          ),
          contentPadding: EdgeInsets.only(left: 19, top: 20),
        ),
      ),
    );
  }
}

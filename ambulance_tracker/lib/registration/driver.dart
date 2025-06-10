import 'dart:io';
import 'package:ambulance_tracker/registration/basic.dart';
import 'package:ambulance_tracker/registration/facilities_screen.dart';
import 'package:ambulance_tracker/registration/login.dart';
import 'package:ambulance_tracker/registration/otpverification.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class DriverRegistration extends StatefulWidget {
  const DriverRegistration({super.key});

  @override
  State<DriverRegistration> createState() => DriverRegistrationState();
}

class DriverRegistrationState extends State<DriverRegistration> {
  String? selectedValue,selectedSector;
  List<String> districts = [
    'Thiruvananthapuram',
    'Kollam',
    'Pathanamthitta',
    'Alappuzha',
    'Kottayam',
    'Idukki',
    'Ernakulam',
    'Thrissur',
    'Palakkad',
    'Malappuram',
    'Kozhikode',
    'Wayanad',
    'Kannur',
    'Kasaragod',
  ];
  List<String> sector=[
     "Emergency Medical Services (EMS)",
    "Non-Emergency Transport",
    "Private Ambulance Services",
    "Military Ambulance Services",
    "Disaster Response and Relief",
    "Air Ambulance Services",
    "Water Ambulance Services",
    "Fire Department Ambulance",
    "Hospital-Based Ambulance",
    "Event Medical Coverage",
    "Industrial/Occupational Health Ambulance"
  ];
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
          padding: EdgeInsets.only(top: 20.0),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SelectionContainer.disabled(
                  child: Text(
                    "DRIVER REGISTRATION",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Roboto',
                      color: Color.fromRGBO(87, 24, 44, 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                CustomTextField(hint: 'NAME'),
                SizedBox(height: 10),
                CustomTextField(hint: 'PHONE NO'),
                SizedBox(height: 10),
                CustomTextField(hint: 'EMAIL ID'),
                SizedBox(height: 10),
                SizedBox(
                  width: 325,
                  height: 55,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(227, 185, 197, 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValue,
                        hint: Text(
                          'SELECT DISTRICT',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 42),
                            fontSize: 16,
                          ),
                        ),
                        isExpanded: true,
                        dropdownColor: Color.fromRGBO(227, 185, 197, 1.0),
                        borderRadius: BorderRadius.circular(10),
                        items:
                            districts.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black.withAlpha(107),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CustomTextField(hint: 'VEHICLE NO'),
                SizedBox(height: 10),
                CustomTextField(hint: 'CAPACITY'),
                SizedBox(height: 10),
                SizedBox(
                  width: 325,
                  height: 55,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(227, 185, 197, 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedSector,
                        hint: Text(
                          'SECTOR',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 42),
                            fontSize: 16,
                          ),
                        ),
                        isExpanded: true,
                        dropdownColor: Color.fromRGBO(227, 185, 197, 1.0),
                        borderRadius: BorderRadius.circular(10),
                        items:
                            sector.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black.withAlpha(107),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 325,
                  height: 55,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(227, 185, 197, 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'FACILITIES',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 42), // opacity ~ 42%
                          fontSize: 16,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          color: Colors.black.withAlpha(107),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> FacilitiesScreen()));
                          },
                        )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 325,
                  height: 55,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(227, 185, 197, 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "IMPORT LICENSE",
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 42),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Colors.black.withAlpha(107),
                            size: 20,
                          ),
                          onPressed: homepage.new,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 265,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OtpVerification()),
                      );
                      print('Account Registered');
                    },
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                      ),
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

class CustomTextField extends StatelessWidget {
  final String hint;

  const CustomTextField({required this.hint, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 325,
      height: 55,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(227, 185, 197, 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 42),
              fontSize: 16,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: dead_code

import 'package:ambulance_tracker/registration/facilities_screen.dart';
import 'package:ambulance_tracker/registration/otpverification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class DriverRegistration extends StatefulWidget {
  const DriverRegistration({super.key});

  @override
  State<DriverRegistration> createState() => DriverRegistrationState();
}

class DriverRegistrationState extends State<DriverRegistration> {
  String? selectedValue, selectedSector;
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
  List<String> sector = [
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
    "Industrial/Occupational Health Ambulance",
  ];
  List<String> selectedFacilities = [];
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController vehicleNocontroller = TextEditingController();
  final TextEditingController capacitycontroller = TextEditingController();
  String? nameError;
  String? phoneError;
  String? emailError;
  String? districtError;
  String? vehiclenoError;
  String? capacityError;
  String? sectorError;
  String? licenseError;

  bool isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  File? image;

  Future<void> pickImage() async {
    if (Platform.isAndroid) {
      var status = await Permission.photos.request(); // For Android 13+
      if (status.isDenied || status.isPermanentlyDenied) {
        print("Permission not granted");
        return;
      }
    }

    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      setState(() {
        image = imageFile;
      });
    } else {
      print("No image selected");
    }
  }

  @override
  void dispose() {
    namecontroller.dispose();
    phonecontroller.dispose();
    vehicleNocontroller.dispose();
    capacitycontroller.dispose();
    emailcontroller.dispose();
    super.dispose();
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
                if (nameError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        nameError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                CustomTextField(hint: 'NAME', controller: namecontroller),
                SizedBox(height: 10),
                if (phoneError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        phoneError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                CustomTextField(hint: 'PHONE NO', controller: phonecontroller),
                SizedBox(height: 10),
                if (emailError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        emailError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                SizedBox(
                  width: 325,
                  height: 55,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(227, 185, 197, 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "EMAIL ID",
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 42),
                          fontSize: 16,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                if (districtError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        districtError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
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
                if (vehiclenoError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        vehiclenoError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                CustomTextField(
                  hint: 'VEHICLE NO',
                  controller: vehicleNocontroller,
                ),
                SizedBox(height: 10),
                if (capacityError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        capacityError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                CustomTextField(
                  hint: 'CAPACITY',
                  controller: capacitycontroller,
                ),
                SizedBox(height: 10),
                if (sectorError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        sectorError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
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
                          if (newValue != null) {
                            setState(() {
                              selectedSector = newValue;
                            });
                          }
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(227, 185, 197, 1.0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onPressed: () async {
                      final List<String>? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => FacilitiesScreen(
                                previouslySelected:
                                    selectedFacilities, // Pass selected list
                              ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          selectedFacilities = result;
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "FACILITIES",
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.6), // ~42% opacity
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.add, color: Colors.black.withAlpha(107)),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),
                if (licenseError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        licenseError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),

                ElevatedButton(
                  onPressed: pickImage,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Color.fromRGBO(227, 185, 197, 1.0),
                    elevation: 3,
                    padding: EdgeInsets.zero,
                  ),
                  child: SizedBox(
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
                              image != null ? image!.path : "IMPORT LICENSE",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 42),
                                fontSize: 14,
                              ),
                              overflow:
                                  TextOverflow
                                      .ellipsis, // Truncate long paths nicely
                            ),
                          ),
                          Icon(
                            Icons.add_a_photo,
                            color: Colors.black.withAlpha(107),
                            size: 20,
                          ),
                        ],
                      ),
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
                      setState(() {
                        nameError =
                            phoneError =
                                emailError =
                                    districtError =
                                        vehiclenoError =
                                            capacityError =
                                                sectorError =
                                                    licenseError = null;

                        if (namecontroller.text.trim().length < 2) {
                          nameError = "Please enter a valid name";
                        }
                        if (!RegExp(
                          r'^\d{10}$',
                        ).hasMatch(phonecontroller.text.trim())) {
                          phoneError = "Enter a valid 10-digit phone number";
                        }
                        if (!isValidEmail(emailcontroller.text.trim())) {
                          emailError = "Enter a valid email address";
                        }
                        if (selectedValue == null) {
                          districtError = "Please select a district";
                        }
                        if (!RegExp(
                          r'^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$',
                        ).hasMatch(
                          vehicleNocontroller.text.trim().toUpperCase(),
                        )) {
                          vehiclenoError =
                              "Enter a valid vehicle number (e.g. KL01AB1234)";
                        }
                        if (capacitycontroller.text.trim().isEmpty ||
                            int.tryParse(capacitycontroller.text.trim()) ==
                                null) {
                          capacityError = "Enter numeric capacity";
                        }
                        if (selectedSector == null) {
                          sectorError = "Please select a sector";
                        }
                        if (image == null) {
                          licenseError = "Please upload your license";
                        }

                        if (nameError == null &&
                            phoneError == null &&
                            emailError == null &&
                            districtError == null &&
                            vehiclenoError == null &&
                            capacityError == null &&
                            sectorError == null &&
                            licenseError == null) {
                          // Submit the data
                          Map<String, dynamic> driverData = {
                            "name": namecontroller.text,
                            "email": emailcontroller.text,
                            "phone_no": phonecontroller.text,
                            "district": selectedValue,
                            "vehicle_no": vehicleNocontroller.text,
                            "capacity": capacitycontroller.text,
                            "sector": selectedSector,
                            "facilities": selectedFacilities,
                            "license": image,
                          };
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => OtpVerification(
                                    email: emailcontroller.text,
                                    Data: driverData,
                                  ),
                            ),
                          );
                        }
                      });
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
  final TextEditingController controller;

  const CustomTextField({
    required this.hint,
    required this.controller,
    super.key,
  });

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
          controller: controller,
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

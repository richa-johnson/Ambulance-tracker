import 'package:ambulance_tracker/registration/otpUser.dart';
import 'package:flutter/material.dart';

class userRegistration extends StatefulWidget {
  const userRegistration({super.key});

  @override
  State<userRegistration> createState() => _userRegistrationState();
}

List<String> district = [
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
String? selectedDistrict;

class _userRegistrationState extends State<userRegistration> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();
  String? nameError;
  String? phoneError;
  String? emailError;
  String? districtError;
  bool isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
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
          child: Padding(
            padding: const EdgeInsets.only(top: 114),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  Text(
                    "USER REGISTRATION",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(87, 24, 44, 1.0),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
                  if (nameError != null) errorText(nameError!),
                  CustomInputField(
                    hintText: 'NAME',
                    controller: namecontroller,
                  ),
                  const SizedBox(height: 20),
                  if (phoneError != null) errorText(phoneError!),
                  CustomInputField(
                    hintText: 'PHONE NUMBER',
                    controller: phonecontroller,
                  ),
                  const SizedBox(height: 20),
                  if (emailError != null) errorText(emailError!),
                  Container(
                    width: 325,
                    height: 66,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(227, 185, 197, 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "EMAIL ID",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(0, 0, 0, 42),
                        ),
                        contentPadding: EdgeInsets.only(left: 19, top: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (districtError != null) errorText(districtError!),
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
                          child: Text(
                            "DISTRICT",
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 42),
                            ),
                          ),
                        ),
                        items:
                            district.map((String item) {
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
                  SizedBox(height: 72),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        nameError =
                            phoneError = emailError = districtError = null;

                        if (namecontroller.text.trim().isEmpty) {
                          nameError = "Please enter your name";
                        }
                        if (!isValidEmail(emailcontroller.text.trim())) {
                          emailError = "Enter a valid email address";
                        }
                        if (phonecontroller.text.trim().length != 10 ||
                            !RegExp(
                              r'^\d{10}$',
                            ).hasMatch(phonecontroller.text.trim())) {
                          phoneError = "Enter a valid 10-digit phone number";
                        }
                        if (selectedDistrict == null) {
                          districtError = "Please select a district";
                        }

                        if (nameError == null &&
                            phoneError == null &&
                            emailError == null &&
                            districtError == null) {
                          Map<String, dynamic> userData = {
                            "user_name": namecontroller.text,
                            "user_mail": emailcontroller.text,
                            "user_phone": phonecontroller.text,
                            "user_district": selectedDistrict,
                          };
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => OtpVerificationUser(
                                    email: emailcontroller.text,
                                    UserData: userData,
                                  ),
                            ),
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                      minimumSize: Size(265, 55),
                    ),
                    child: Text(
                      "SUBMIT",
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
Widget errorText(String msg) => Padding(
        padding: const EdgeInsets.only(left: 30, bottom: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(msg, style: TextStyle(color: Colors.red)),
        ),
      );
}


class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

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
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,

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

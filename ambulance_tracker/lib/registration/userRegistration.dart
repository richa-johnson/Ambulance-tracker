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
                  CustomInputField(
                    hintText: 'NAME',
                    controller: namecontroller,
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    hintText: 'PHONE NUMBER',
                    controller: phonecontroller,
                  ),
                  const SizedBox(height: 20),
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
                      String email = emailcontroller.text.trim();
                      if (isValidEmail(email)) {
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
                                  email: email,
                                  UserData: userData,
                                ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Enter a valid email address"),
                          ),
                        );
                      }
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
}

class CustomInputField extends StatelessWidget{
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
  Widget build(BuildContext context){
    return Container(
      width: 325,
      height: 66,
      decoration: BoxDecoration(
        color: Color.fromRGBO(227, 185, 197,1.0),
        borderRadius: BorderRadius.circular(10)
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
          contentPadding: EdgeInsets.only(left:19,top:20),
        ),
      ),
    );
  }
}
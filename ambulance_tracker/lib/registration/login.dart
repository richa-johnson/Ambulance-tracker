import 'package:ambulance_tracker/dashbord/userdashbordScreen.dart';
import 'package:ambulance_tracker/registration/forgotpassword.dart';
import 'package:ambulance_tracker/registration/userRegistration.dart';
import 'package:flutter/material.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
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
                    "LOGIN",
                    style: TextStyle(
                      color: Color.fromRGBO(87, 24, 44, 1),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
                  CustomInputField(hintText: 'PHONE NUMBER',controller: phonecontroller,),
                  const SizedBox(height: 20),
                  CustomInputField(hintText: 'PASSWORD',controller: passwordcontroller,),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 50),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Forgotpassword(),
                            ),
                          );
                        },
                        child: Text(
                          "forgot password?",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 255, 1.0),
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            decorationColor: Color.fromRGBO(0, 0, 0, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 72),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => userdashboard(),
                        ),
                      );
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

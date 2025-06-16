import 'package:ambulance_tracker/registration/password.dart';
import 'package:email_otp_auth/email_otp_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpVerification extends StatefulWidget {
  final String email;
  final Map<String, dynamic> Data;
  const OtpVerification({
    super.key,
    required this.email,
    required this.Data,
  });

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final int otpLength = 6;
  late List<FocusNode> focusNodes;
  late List<TextEditingController> controllers;
  List<String> otpvalues = List.filled(6, '');

  Future<void> sendOtpEmail(String email) async {
    await EmailOtpAuth.sendOTP(email: email);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("OTP sent to your via email to ${widget.email}")),
    );
  }

  Future<void> verifyOtp() async {
    String otp = otpvalues.join();
    await EmailOtpAuth.verifyOtp(otp: otp);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Password(Data: widget.Data),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(otpLength, (_) => FocusNode());
    controllers = List.generate(otpLength, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
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
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 72),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  Text(
                    "OTP VERIFICATION",
                    style: TextStyle(
                      color: Color.fromRGBO(87, 24, 44, 1.0),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      sendOtpEmail(widget.email);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                      minimumSize: Size(265, 55),
                    ),
                    child: Text(
                      "SEND OTP",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                        fontSize: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "ENTER OTP CODE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(87, 24, 44, 1.0),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(otpLength, (index) {
                      return CustomOtp(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        onChanged: (value) {
                          setState(() {
                            otpvalues[index] = value;
                          });
                          if (value.isNotEmpty && index < otpLength - 1) {
                            FocusScope.of(
                              context,
                            ).requestFocus(focusNodes[index + 1]);
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(
                              context,
                            ).requestFocus(focusNodes[index - 1]);
                          } else if (index == otpLength - 1) {
                            focusNodes[index].unfocus();
                          }
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 80),
                  ElevatedButton(
                    onPressed:
                        otpvalues.every((val) => val.isNotEmpty)
                            ? () {
                              verifyOtp();
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                      minimumSize: Size(161, 47),
                    ),
                    child: Text(
                      "VERIFY",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                        fontSize: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 120),
                  Text(
                    "DID NOT RECEIVE OTP?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color.fromRGBO(87, 24, 44, 1.0)),
                  ),
                  Text(
                    "RESEND",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 255, 1.0),
                      decoration: TextDecoration.underline,
                      decorationColor: Color.fromRGBO(0, 0, 255, 1),
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

class CustomOtp extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;

  const CustomOtp({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 40,
      decoration: BoxDecoration(
        color: Color.fromRGBO(210, 209, 209, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(border: InputBorder.none, counterText: ''),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
      ),
    );
  }
}

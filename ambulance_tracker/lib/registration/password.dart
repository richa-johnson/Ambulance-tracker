import 'dart:io';
import 'package:ambulance_tracker/constant.dart';
import "package:ambulance_tracker/registration/login.dart";
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

class Password extends StatefulWidget {
  final Map<String, dynamic> Data;
  const Password({super.key, required this.Data});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final TextEditingController set = TextEditingController();
  final TextEditingController confirm = TextEditingController();
  bool _obscureText = true;
  bool _obscure = true;
  String? errorText;
  bool isPasswordValid(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
    return regex.hasMatch(password);
  }

  @override
  void initState() {
    super.initState();
    confirm.addListener(checkPasswordMatch);
  }

  void checkPasswordMatch() {
    final password = set.text.trim();
    final same = confirm.text.trim();
    setState(() {
      if (same.isEmpty) {
        errorText = null;
      } else if (password != same) {
        errorText = "Passwords do not match";
      } else {
        errorText = null;
      }
    });
  }

  @override
  void dispose() {
    set.dispose();
    confirm.dispose();
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
          padding: EdgeInsets.only(top: 200),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SelectionContainer.disabled(
                  child: Text(
                    "SET PASSWORD",
                    style: TextStyle(
                      color: Color.fromRGBO(87, 24, 44, 1.0),
                      fontFamily: "Roboto",
                      fontSize: 32,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: 325,
                  height: 55,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(227, 185, 197, 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: set,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "ENTER NEW PASSWORD",
                        hintStyle: TextStyle(
                          color: Colors.black.withAlpha(107),
                          fontSize: 16,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black.withAlpha(107),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: 325,
                  height: 55,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(227, 185, 197, 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: confirm,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "CONFIRM NEW PASSWORD",
                        hintStyle: TextStyle(
                          color: Colors.black.withAlpha(107),
                          fontSize: 16,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black.withAlpha(107),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscure = !_obscure;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                if (errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorText!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                SizedBox(height: 30),
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
                    onPressed: () async {
                      final password = set.text.trim();
                      final confirmPassword = confirm.text.trim();

                      if (password.isEmpty || confirmPassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Password fields cannot be empty."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (password != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Passwords do not match."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (!isPasswordValid(password)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Password must be at least 8 characters long and include:\n- Uppercase letter\n- Lowercase letter\n- Number\n- Special character",
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 5),
                          ),
                        );
                        return;
                      }

                      final fullData = {...widget.Data, "password": password};

                      File imageFile = fullData["license"];
                      fullData.remove("license");

                      final url = Uri.parse(driverregisterURL);

                      var request = http.MultipartRequest("POST", url);

                      request.files.add(
                        await http.MultipartFile.fromPath(
                          'license',
                          imageFile.path,
                        ),
                      );

                      fullData.forEach((key, value) {
                        if (key == "facilities" && value is List) {
                          for (int i = 0; i < value.length; i++) {
                            request.fields["facilities[$i]"] = value[i];
                          }
                        } else {
                          request.fields[key] = value.toString();
                        }
                      });

                      try {
                        var streamedResponse = await request.send();
                        var response = await http.Response.fromStream(
                          streamedResponse,
                        );

                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Registration Successful")),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Registration failed. Please try again.",
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Something went wrong. Please try again.",
                            ),
                          ),
                        );
                      }
                    },

                    child: Text(
                      "SUBMIT",
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

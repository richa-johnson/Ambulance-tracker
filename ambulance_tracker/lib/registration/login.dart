import 'package:ambulance_tracker/dashbord/admindashboard.dart';
import 'package:ambulance_tracker/dashbord/driverDasboardScreen.dart';
import 'package:ambulance_tracker/dashbord/userdashbordScreen.dart';
import 'package:ambulance_tracker/models/user.dart';
import 'package:ambulance_tracker/registration/RegisterScreen.dart';
import 'package:ambulance_tracker/registration/forgotpassword.dart';
import 'package:ambulance_tracker/registration/userRegistration.dart';
import 'package:ambulance_tracker/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final response = await login(txtEmail.text.trim(), txtPassword.text.trim());

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (response.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.error!)));
      return;
    } else {
      _saveAndRedirectToHome(response.data as User);
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString('token', user.token ?? "");
    await pref.setInt('userId', user.id ?? 0);
    if (user.role == 'user') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const userdashboard()),
        (route) => false,
      );
    } else if (user.role == 'driver') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const driverDashboard()),
        (route) => false,
      );
    } else if (user.role == 'admin') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AdminDashboard()),
        (route) => false,
      );
    } else {
      //
    }
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
                child: Form(
                  key: _formKey,
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

                      CustomInputField(
                        controller: txtEmail,
                        hintText: 'EMAIL ID',
                        keyboardType: TextInputType.emailAddress,
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? 'Enter email' : null,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 325,
                        height: 66,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(227, 185, 197, 1.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: txtPassword,
                          obscureText: _obscureText,
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Enter password'
                                      : null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(0, 0, 0, 42),
                            ),
                            contentPadding: EdgeInsets.only(left: 19, top: 20),
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
                                decorationColor: Color.fromRGBO(0, 0, 255, 1.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 72),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                          minimumSize: Size(265, 55),
                        ),
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'SUBMIT',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                      SizedBox(height: 150),
                      Text(
                      'DON\'T HAVE AN ACCOUNT?',
                      strutStyle: StrutStyle(
                        forceStrutHeight: true,
                        height: 1.0,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(87, 24, 44, 1.0),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'REGISTER',
                        strutStyle: StrutStyle(
                          forceStrutHeight: true,
                          height: 1.0,
                        ),
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }


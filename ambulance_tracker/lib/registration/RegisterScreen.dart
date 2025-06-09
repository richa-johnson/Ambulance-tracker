import 'package:ambulance_tracker/registration/driver.dart';
import 'package:ambulance_tracker/registration/login.dart';
import 'package:ambulance_tracker/registration/user.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'REGISTER',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(87, 24, 44, 1.0),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        shadowColor: const Color.fromARGB(255, 0, 0, 0),
                        minimumSize: Size(333, 58),
                        backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => userRegistration(),
                          ),
                        );
                      },
                
                      child: Text(
                        'USER',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Color.fromRGBO(87, 24, 44, 1.0),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                
                          // fontFamily:
                        ),
                      ),
                    ),
                
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        shadowColor: const Color.fromARGB(255, 0, 0, 0),
                        minimumSize: Size(333, 58),
                        backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DriverRegistration(),
                          ),
                        );
                      },
                      child: Text(
                        'DRIVER',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ALREADY HAVE ACCOUNT?',
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
                            builder: (context) => loginPage(),
                          ),
                        );
                      },
                      child: Text(
                        'LOGIN',
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
              ],
            ),
          ),

          // child:  Center(
        ),
      ),
    );
  }
}


// class Registerscreen extends StatefulWidget {
//   const Registerscreen({super.key});

//   @override
//   State<Registerscreen> createState() => _RegisterscreenState();
// }

// class _RegisterscreenState extends State<Registerscreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: Align(
//           alignment: Alignment.topLeft,
//           child: Image.asset(
//             'assets/title.png',
//             fit: BoxFit.contain,
//             height: 180,
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),

//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color.fromRGBO(159, 13, 55, 1.0),
//               Color.fromRGBO(189, 83, 114, 1.0),
//             ],
//           ),
//         ),
//         padding: EdgeInsets.only(
//           top: MediaQuery.of(context).padding.top + kToolbarHeight,
//           left: 10.0,
//           right: 10.0,
//           bottom: 10.0,
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// // // }

import 'package:flutter/material.dart';

class userdashboard extends StatefulWidget {
  const userdashboard({super.key});

  @override
  State<userdashboard> createState() => _userdashboardState();
}

class _userdashboardState extends State<userdashboard> {
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
          child: Column(
                children: [
                  Container(
                    width:double.infinity,
                    height: 76,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(227, 185, 197, 1),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                    bottom: Radius.circular(0),
                  ),
                ),
                alignment:Alignment.centerRight,
                child: Padding(
                  padding:EdgeInsetsGeometry.symmetric(horizontal: 10),
                  child:IconButton(onPressed: (){}, icon:Icon(Icons.person),iconSize: 30,)),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 361,
                        height: 231,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(187, 51, 90, 1),
                          borderRadius: BorderRadius.circular(10)
                        ),
                      )
                      ,Container(
                        width: 361,
                        height: 231,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(187, 51, 90, 1),
                          borderRadius: BorderRadius.circular(10)
                        ),
                      )
                      
                    ],
                  )
                ],

                
               ),
      ),
    )
    );
  }
}

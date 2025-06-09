import 'package:flutter/material.dart';

class RegisterUserScreen extends StatefulWidget {
  @override 
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("GeeksforGeeks"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 110.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 100,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/images/Instagram.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone number, email or username',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(

                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),

          SizedBox(
            height: 65,
            width: 360,
            child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    child: Text( 'Log in ', style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: (){
                      print('Successfully log in ');
                    },

                  ),
                ),
              ),
          ),

            SizedBox(
              height: 50,
            ),
            Container(
                child: Center(
                  child: Row(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 62),
                        child: Text('Forgot your login details? '),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left:1.0),
                        child: InkWell(
                          onTap: (){
                            print('hello');
                          },
                            child: Text('Get help logging in.', style: TextStyle(fontSize: 14, color: Colors.blue),)),
                      )
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
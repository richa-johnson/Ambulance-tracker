import 'package:ambulance_tracker/registration/basic.dart';
import 'package:flutter/material.dart';

class userEdit extends StatefulWidget {
  const userEdit({super.key});

  @override
  State<userEdit> createState() => _userEditState();
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

class _userEditState extends State<userEdit> {
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
          child:Padding(
            padding: const EdgeInsets.only(top: 114),
            child:SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
            child: Column(
              children: [
                Text(
                  "EDIT YOUR PROFILE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(87, 24, 44,1.0),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(padding: EdgeInsets.only(left: 40),
                    child: Text(
                      "NAME: ",
                    ),
                  ),
                ),
                CustomInputField(hintText: 'NAME'),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(padding: EdgeInsets.only(left: 40),
                    child: Text(
                      "PHONE NUMBER: ",
                    ),
                  ),
                ),
                CustomInputField(hintText: 'PHONE NUMBER'),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(padding: EdgeInsets.only(left: 40),
                    child: Text(
                      "EMAIL ID: ",
                    ),
                  ),
                ),
                CustomInputField(hintText: 'EMAIL ID'),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(padding: EdgeInsets.only(left: 40),
                    child: Text(
                      "DISTRICT: ",
                    ),
                  ),
                ),
                Container(
                  width: 325,
                  height: 66,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(227, 185, 197,1.0),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        value: selectedDistrict,           
                        hint: Padding(padding: const EdgeInsets.only(left:19),
                          child: Text("DISTRICT",style: TextStyle(color: Color.fromRGBO(0, 0, 0, 42)),),
                        ),
                        items: district.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Padding(
                              padding: EdgeInsets.only(left:19),
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
                ElevatedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>homepage())
                  );
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                  minimumSize: Size(265,55),
                  
                ),
                child: Text(
                  "UPDATE",
                  style: TextStyle(color: Color.fromRGBO(255,255,255,1.0), fontSize: 24),
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
  final String hintText;
  const CustomInputField({super.key, required this.hintText});

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

import 'package:flutter/material.dart';
import 'package:ambulance_tracker/registration/user.dart';
import 'package:flutter/services.dart';

class patientDetailsForm extends StatefulWidget {
  const patientDetailsForm({super.key});

  @override
  State<patientDetailsForm> createState() => _patientDetailsFormState();
}

class _patientDetailsFormState extends State<patientDetailsForm> {
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
            padding: const EdgeInsets.only(top: 0),
            child:SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
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
                const SizedBox(height: 50),
                Text(
                  "PATIENT DETAILS",
                  style: TextStyle(
                    color: Color.fromRGBO(87, 24, 44, 1),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                CustomInputFieldNumber(hintText: 'NUMBER OF PATIENTS'),
                Text(
                  "ADD PATIENT DETAILS",
                  style: TextStyle(
                    
                  ),
                ),
                const SizedBox(height: 50),
                CustomInputField(hintText: 'NAME'),
                const SizedBox(height: 20),
                CustomInputFieldNumber(hintText: 'AGE'),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class CustomInputFieldNumber extends StatelessWidget{
  final String hintText;
  const CustomInputFieldNumber({Key?key, required this.hintText}):super(key: key);

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
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
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


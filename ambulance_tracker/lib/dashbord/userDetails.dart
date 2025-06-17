import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/services/user_services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  List<UserModel> userList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("No token found.Please login.");
      return;
    }
    final response = await http.get(
      Uri.parse(getUserURL),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
    final List<dynamic> data = decoded is List
        ? decoded
        : (decoded['data'] ?? []); 
      setState(() {
        userList = data.map((json) => UserModel.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("Failed to load users: ${response.body}");
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
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "USER DETAILS",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(87, 24, 44, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child:
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Table(
                                defaultColumnWidth: IntrinsicColumnWidth(),
                                border: TableBorder.all(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                ),
                                children: [
                                  UserDetailsTable(
                                    slno: "Sl No  ",
                                    name: "Name  ",
                                    phoneno: "Phone No  ",
                                    emailid: "Email Id  ",
                                    district: "District  ",
                                  ).build(),
                                  for (var user in userList)
                                    UserDetailsTable(
                                      slno: user.slno,
                                      name: user.name,
                                      phoneno: user.phoneno,
                                      emailid: user.emailid,
                                      district: user.district,
                                    ).build(),
                                ],
                              ),
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetailsTable {
  final String slno;
  final String name;
  final String phoneno;
  final String emailid;
  final String district;

  UserDetailsTable({
    required this.slno,
    required this.name,
    required this.phoneno,
    required this.emailid,
    required this.district,
  });

  TableRow build() {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w900,
      fontSize: 17,
    );

    return TableRow(
      children: [
        tableCell(slno, textStyle),
        tableCell(name, textStyle),
        tableCell(phoneno, textStyle),
        tableCell(emailid, textStyle),
        tableCell(district, textStyle),
      ],
    );
  }

  Widget tableCell(String content, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        content,
        style: style,
        overflow: TextOverflow.visible,
        softWrap: false,
      ),
    );
  }
}

class UserModel {
  final String slno;
  final String name;
  final String phoneno;
  final String emailid;
  final String district;

  UserModel({
    required this.slno,
    required this.name,
    required this.phoneno,
    required this.emailid,
    required this.district,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      slno: json['slno'].toString(),
      name: json['name'],
      phoneno: json['phoneno'],
      emailid: json['emailid'],
      district: json['district'],
    );
  }
}

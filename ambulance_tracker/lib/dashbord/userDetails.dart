import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/dashbord/admindashboard.dart';
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
  TextEditingController searchController = TextEditingController();
  List<UserModel> filteredList = [];
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
      final List<dynamic> data =
          decoded is List ? decoded : (decoded['data'] ?? []);

      setState(() {
        userList = data.map((json) => UserModel.fromJson(json)).toList();
        filteredList = List.from(userList); // initialize filtered list
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("Failed to load users: ${response.body}");
    }
  }

  void _filterUsers(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredList =
          userList.where((user) {
            return user.name.toLowerCase().contains(lowerQuery) ||
                user.phoneno.toLowerCase().contains(lowerQuery) ||
                user.emailid.toLowerCase().contains(lowerQuery) ||
                user.district.toLowerCase().contains(lowerQuery);
          }).toList();
    });
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
              Container(
                width: double.infinity,
                height: 76,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(227, 185, 197, 1),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                    bottom: Radius.circular(0),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: IconButton(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminDashboard())),
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                    ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: searchController,
                  onChanged: _filterUsers,
                  decoration: InputDecoration(
                    hintText: 'Search by name, phone, email or district',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
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
                                  for (var user in filteredList)
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

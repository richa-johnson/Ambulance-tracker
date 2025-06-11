import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String slno="1   ",name="dIYA  ",phoneno="78987968  ",emailid="HJKHALJNCLkhjnmhjgkhjbknhjloikjnm  ",district="MDJDS  ";
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
                Text("USER DETAILS", textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(87, 24, 44,1), fontWeight: FontWeight.bold,fontSize: 32),),
                SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
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
                              style: BorderStyle.solid
                            ),
                            children: [
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                              UserDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ").build(),
                              UserDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district).build(),
                                                
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

class UserDetailsTable{
  final String slno;
  final String name;
  final String phoneno;
  final String emailid;
  final String district;
 
  UserDetailsTable({required this.slno,required this.name,required this.phoneno,required this.emailid,required this.district});

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


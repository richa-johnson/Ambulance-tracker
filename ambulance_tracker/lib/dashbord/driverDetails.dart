import 'package:flutter/material.dart';

class DriverDetails extends StatefulWidget {
  const DriverDetails({super.key});

  @override
  State<DriverDetails> createState() => _DriverDetailsState();
}

class _DriverDetailsState extends State<DriverDetails> {
  String slno="1   ",name="dIYA  ",phoneno="78987968  ",emailid="HJKHALJNCLkhjnmhjgkhjbknhjloikjnm  ",district="MDJDS  ",vehicleno="238924",capacity="3",sector="gobewrmfscnt",facilities="jklsadfhaskjam",license="sdfhlkajsvnssmc";
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
                Text("DRIVER DETAILS", textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(87, 24, 44,1), fontWeight: FontWeight.bold,fontSize: 32),),
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
                              DriverDetailsTable(slno: "Sl No  ", name: "Name  ", phoneno: "Phone No  ", emailid: "Email Id  ", district: "District  ", vehicleno: "Vehicle No", capacity: "Capacity", sector: "Sector", facilities: "Facilities", license: "License").build(),
                              for (int i=0;i<10;i++)
                                DriverDetailsTable(slno: slno, name: name, phoneno: phoneno, emailid: emailid, district: district, vehicleno: vehicleno, capacity: capacity, sector: sector, facilities: facilities, license: license).build(),
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

class DriverDetailsTable{
  final String slno;
  final String name;
  final String phoneno;
  final String emailid;
  final String district;
  final String vehicleno;
  final String capacity;
  final String facilities;
  final String sector;
  final String license;
 
  DriverDetailsTable({required this.slno,required this.name,required this.phoneno,required this.emailid,required this.district,required this.vehicleno,required this.capacity,required this.sector,required this.facilities,required this.license});

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
        tableCell(vehicleno, textStyle),
        tableCell(capacity, textStyle),
        tableCell(sector, textStyle),
        tableCell(facilities, textStyle),
        tableCell(license, textStyle),
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


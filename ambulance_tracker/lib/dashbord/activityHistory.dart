import 'package:flutter/material.dart';

class ActivityHistory extends StatefulWidget {
  const ActivityHistory({super.key});

  @override
  State<ActivityHistory> createState() => _ActivityHistoryState();
}

class _ActivityHistoryState extends State<ActivityHistory> {
  String slno="1   ",uname="dIYA  ",uphoneno="78987968  ",dname="djfkhsjf",dphoneno="9408780909",vehicleno="238924",pcount="3",pname="gobewrmfscnt",location="jklsadfhaskjam",date="sdfhlkajsvnssmc",time="78:89:90";
  int i=0;
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
                Text("ACTIVITY HISTORY", textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(87, 24, 44,1), fontWeight: FontWeight.bold,fontSize: 32),),
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
                              ActivityHistoryTable(slno: "Sl No", uname: "User Name", uphoneno: "User Phone No", dname: "Driver Name", dphoneno: "Driver Phone No", vehicleno: "Vehicle No", pcount: "Patient count", pname: "Patient Name", location: "Location", date: "Date", time: "Time").build(),
                              for (int i=0;i<10;i++)
                                ActivityHistoryTable(slno: slno, uname: uname, uphoneno: uphoneno, dname: dname, dphoneno: dphoneno, vehicleno: vehicleno, pcount: pcount, pname: pname, location: location, date: date, time: time).build(),
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

class ActivityHistoryTable{
  final String slno;
  final String uname;
  final String uphoneno;
  final String dname;
  final String dphoneno;
  final String vehicleno;
  final String pcount;
  final String pname;
  final String location;
  final String date;
  final String time;
 
  ActivityHistoryTable({required this.slno,required this.uname,required this.uphoneno,required this.dname,required this.dphoneno,required this.vehicleno,required this.pcount,required this.pname,required this.location,required this.date,required this.time});

  TableRow build() {
  TextStyle textStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w900,
    fontSize: 17,
  );

    return TableRow(
      children: [
        tableCell(slno, textStyle),
        tableCell(uname, textStyle),
        tableCell(uphoneno, textStyle),
        tableCell(dname, textStyle),
        tableCell(dphoneno, textStyle),
        tableCell(vehicleno, textStyle),
        tableCell(pcount, textStyle),
        tableCell(pname, textStyle),
        tableCell(location, textStyle),
        tableCell(date, textStyle),
        tableCell(time, textStyle),
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


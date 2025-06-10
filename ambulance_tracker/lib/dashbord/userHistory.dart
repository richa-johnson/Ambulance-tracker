import 'package:flutter/material.dart';

class UserHistory extends StatefulWidget {
  const UserHistory({super.key});

  @override
  State<UserHistory> createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
  String dname="ravi",phoneno="7736798040",pcount="7",pname="harsha",age="7",bloodGroup="B+",location="snadkugfheanjzxd",date="77-36-7980",time="77:36:79";

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
          padding: EdgeInsets.only(top: 10,right: 10,left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Container(
            padding: EdgeInsets.only(top: 30,right: 10,left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(156, 150, 150, 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "YOUR ACTIVITY HISTORY",
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(10, (index)=> Padding(
                        padding: (EdgeInsets.only(bottom: 10)),
                          child: SizedBox(
                            height: 265,
                            width: 350,
                            child: Card(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Table(
                                  columnWidths: {
                                    0:IntrinsicColumnWidth(),
                                    1:FixedColumnWidth(10),
                                    2:FlexColumnWidth()
                                  },
                                  children: [
                                    ActivityHistoryTable(label: "Driver Name", value: dname).build(),
                                    ActivityHistoryTable(label: "Phone No", value: phoneno).build(),
                                    ActivityHistoryTable(label: "No of Patients    ", value: pcount).build(),
                                    ActivityHistoryTable(label: "Patient Name", value: pname).build(),
                                    ActivityHistoryTable(label: "Age", value: age).build(),
                                    ActivityHistoryTable(label: "Blood Group", value: bloodGroup).build(),
                                    ActivityHistoryTable(label: "Location", value: location).build(),
                                    ActivityHistoryTable(label: "Date", value: date).build(),
                                    ActivityHistoryTable(label: "Time", value: time).build(),
                                  ],
                                ),
                              ),
                            )
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class ActivityHistoryTable{
  final String label;
  final String seperator;
  final String value;
 
  ActivityHistoryTable({required this.label,this.seperator=":",required this.value});

  TableRow build(){
    return TableRow(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontWeight: FontWeight.w900,
            fontSize: 17
          ),
        ),
        Text(
          seperator,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontWeight: FontWeight.w900,
            fontSize: 17
          ),
        ),
        Text(
          value, 
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontWeight: FontWeight.w900,
            fontSize: 17
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  bool selectAll = false;
  final List<String> facilities = [
    'Facility1',
    'Facility2',
    'abcd',
    'Facility4',
    'Facility5',
    'Facility6',
    'abdr7',
    'Facility8',
    'Facility9',
    'Facility10',
    'Facility11',
    'Facility12',
    'Facility13',
  ];

  late List<bool> checkboxValues;
  TextEditingController searchController = TextEditingController();
  List<String> filteredFacilities = [];

  @override
  void initState() {
    super.initState();
    checkboxValues = List.generate(facilities.length, (_) => false);
    filteredFacilities = List.from(facilities); // show all at first
    searchController.addListener(_filterFacilities);
  }

  void _filterFacilities() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredFacilities =
          facilities
              .where((facility) => facility.toLowerCase().contains(query))
              .toList();
    });
  }

  void toggleselectall(bool? value) {
    setState(() {
      selectAll = value!;
      for (int i = 0; i < checkboxValues.length; i++) {
        checkboxValues[i] = value;
      }
    });
  }

  void toggleIndividual(int index, bool? value) {
    setState(() {
      checkboxValues[index] = value ?? false;
      selectAll = checkboxValues.every((item) => item);
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

        //white box
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //grey facility container
              Container(
                height: 65,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, 1),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                    bottom: Radius.circular(0),
                  ),
                ),
                // alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 0,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 75,
                      ),
                      child: Center(
                        child: Text(
                          'FACILITIES',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(87, 24, 44, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Selectall
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Text(
                  'SELECT ALL',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                value: selectAll,
                onChanged: toggleselectall,
              ),

              //search bar
              Container(
                width: 360,
                height: 56,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, 1),
                  borderRadius: BorderRadius.all(Radius.circular(28)),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'SEARCH',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon:
                        searchController.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                FocusScope.of(
                                  context,
                                ).unfocus(); // optionally dismiss keyboard
                              },
                            )
                            : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                  ),
                ),
              ),

              // checkboxlist
              Expanded(
                child: SizedBox(
                  width: 350,
                  // decoration: BoxDecoration(color: Colors.amber),
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(filteredFacilities.length, (
                        index,
                      ) {
                        String item = filteredFacilities[index];
                        int originalIndex = facilities.indexOf(
                          item,
                        ); // to sync checkbox status

                        return CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          title: Text(
                            item,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          value: checkboxValues[originalIndex],
                          onChanged:
                              (value) => toggleIndividual(originalIndex, value),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              //add icon
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child:Row(
                  children: [
                  
                    Icon(Icons.add_circle_outline),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child:Text('ADD',style: TextStyle(
                      fontWeight:FontWeight.w500,
                      
                      
                    ),),),
                
                  ],
                )
              ),
              //applybutton
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    shadowColor: const Color.fromARGB(255, 0, 0, 0),
                    minimumSize: Size(161, 47),
                    backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                  ),
                  onPressed: () {},
                  child: Text(
                    'APPLY',
                    style: TextStyle(fontSize: 24, color: Colors.white),
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

import 'package:ambulance_tracker/registration/driver.dart';
import 'package:flutter/material.dart';

class FacilitiesScreen extends StatefulWidget {
  final List<String>? previouslySelected;

  const FacilitiesScreen({Key? key, this.previouslySelected}) : super(key: key);

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  bool selectAll = false;
  final List<String> facilities = [
    'Oxygen cylinder with mask',
    'Stretcher and wheelchair',
    'Basic monitoring equipment',
    'Splints & immobilization devices',
    'Suction device',
    'Cardiac Ambulance',
    'advanced Ventilator',
    'Multi-parameter patient monitor',
    'Intravenous (IV) supplies',
    'Power backup',
    'UV disinfection light',
    'Paramedic staff and critical care physician',
    'hydraulic lift for stretchers',
    'GPS and route optimization system',
    'Neonatal Ambulance',
    'Mortuary Ambulance',
  ];

  late List<bool> checkboxValues;
  TextEditingController searchController = TextEditingController();
  List<String> filteredFacilities = [];
  void _showAddFacilityDialog() {
    TextEditingController newFacilityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Facility'),
          content: TextField(
            controller: newFacilityController,
            decoration: InputDecoration(
              hintText: 'Enter facility name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                String newFacility = newFacilityController.text.trim();

                if (newFacility.isEmpty) {
                  // Optionally show a warning/snackbar
                  return;
                }

                // Check for duplicates case-insensitively
                bool alreadyExists = facilities.any(
                  (facility) =>
                      facility.toLowerCase() == newFacility.toLowerCase(),
                );

                if (!alreadyExists) {
                  setState(() {
                    facilities.add(newFacility);
                    checkboxValues.add(true); // auto-select new item
                    _filterFacilities(); // refresh sorted/filtered list
                  });
                }

                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('ADD'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkboxValues = List.generate(facilities.length, (index) {
      return widget.previouslySelected?.contains(facilities[index]) ?? false;
    });
    filteredFacilities = List.from(facilities);
    searchController.addListener(_filterFacilities);

    // update selectAll if all are selected
    selectAll = checkboxValues.every((val) => val == true);
  }

  void _filterFacilities() {
    String query = searchController.text.toLowerCase();
    List<String> result =
        facilities
            .where((facility) => facility.toLowerCase().contains(query))
            .toList();

    // Bring selected ones first
    result.sort((a, b) {
      int aIndex = facilities.indexOf(a);
      int bIndex = facilities.indexOf(b);
      bool aSelected = checkboxValues[aIndex];
      bool bSelected = checkboxValues[bIndex];

      if (aSelected && !bSelected) return -1;
      if (!aSelected && bSelected) return 1;
      return a.compareTo(b); // Alphabetical fallback
    });

    setState(() {
      filteredFacilities = result;
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
      _filterFacilities(); // re-sort list based on updated selection
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: GestureDetector(
                    onTap: _showAddFacilityDialog,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline),
                        SizedBox(width: 5),
                        Text(
                          'ADD',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    shadowColor: const Color.fromARGB(255, 0, 0, 0),
                    minimumSize: Size(161, 47),
                    backgroundColor: Color.fromRGBO(159, 13, 55, 1.0),
                  ),
                  onPressed: () {
                    List<String> selected = [];
                    for (int i = 0; i < facilities.length; i++) {
                      if (checkboxValues[i]) {
                        selected.add(facilities[i]);
                      }
                    }
                    Navigator.pop(context, selected);
                  },
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

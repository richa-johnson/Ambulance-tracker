import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/driver_edit_controller.dart';
import '../dashbord/driverDasboardScreen.dart';
import '../registration/facilities_screen.dart';

class DriverEdit extends StatefulWidget {
  const DriverEdit({super.key});
  @override
  State<DriverEdit> createState() => _DriverEditState();
}

class _DriverEditState extends State<DriverEdit> {
  final ctrl = Get.put(DriverEditController());
  final List<String> districts = [
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
  final List<String> sector = [
    'Emergency Medical Services (EMS)',
    'Non-Emergency Transport',
    'Private Ambulance Services',
    'Military Ambulance Services',
    'Disaster Response and Relief',
    'Air Ambulance Services',
    'Water Ambulance Services',
    'Fire Department Ambulance',
    'Hospital-Based Ambulance',
    'Event Medical Coverage',
    'Industrial/Occupational Health Ambulance',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Image.asset(
            'assets/title.png',
            height: 180,
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(
        () =>
            ctrl.loading.value
                ? const Center(child: CircularProgressIndicator())
                : _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF9F0D37), Color(0xFFBD5372)],
      ),
    ),
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top + kToolbarHeight,
      left: 10,
      right: 10,
      bottom: 10,
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              'EDIT YOUR PROFILE',
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'Roboto',
                color: Color(0xFF57182C),
              ),
            ),
            const SizedBox(height: 10),
            _label('NAME:'),
            _text(ctrl.nameCtrl, 'NAME'),
            _gap(),
            _label('PHONE NO:'),
            _text(ctrl.phoneCtrl, 'PHONE NO', TextInputType.phone),
            _gap(),
            _label('DISTRICT:'),
            _dropdown(districts, ctrl.district, 'DISTRICT'),
            _gap(),
            _label('VEHICLE NO:'),
            _text(ctrl.vehNoCtrl, 'VEHICLE NO'),
            _gap(),
            _label('CAPACITY:'),
            _text(ctrl.capacityCtrl, 'CAPACITY'),
            _gap(),
            _label('SECTOR:'),
            _dropdown(sector, ctrl.sector, 'SECTOR'),
            _gap(),
            _label('FACILITIES:'),
            _facilityField(context),
            const SizedBox(height: 20),
            _updateBtn(),
          ],
        ),
      ),
    ),
  );

  Widget _label(String t) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(padding: const EdgeInsets.only(left: 40), child: Text(t)),
  );

  Widget _gap() => const SizedBox(height: 10);

  Widget _text(TextEditingController c, String hint, [TextInputType? k]) =>
      SizedBox(
        width: 325,
        height: 55,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE3B9C5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: c,
            keyboardType: k,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
          ),
        ),
      );

  Widget _dropdown(List<String> items, RxnString sel, String hint) => SizedBox(
    width: 325,
    height: 55,
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3B9C5),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: sel.value,
            hint: Text(
              hint,
              style: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 42),
                fontSize: 16,
              ),
            ),
            isExpanded: true,
            items:
                items
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
            onChanged: (v) => sel.value = v,
          ),
        ),
      ),
    ),
  );

  Widget _facilityField(BuildContext context) => SizedBox(
    width: 325,
    height: 55,
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3B9C5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: ctrl.facilitiesCtrl,
        readOnly: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'FACILITIES',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final selected = await Navigator.push<List<String>>(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => FacilitiesScreen(
                        previouslySelected: ctrl.facilities.toList(),
                      ),
                ),
              );
              if (selected != null) {
                ctrl.facilities
                  ..clear()
                  ..addAll(selected);
                ctrl.facilitiesCtrl.text = selected.join(', ');
              }
            },
          ),
        ),
      ),
    ),
  );

  Widget _updateBtn() => SizedBox(
    width: 265,
    height: 55,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF9F0D37),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: ctrl.save,
      child: const Text(
        'UPDATE',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    ),
  );
}
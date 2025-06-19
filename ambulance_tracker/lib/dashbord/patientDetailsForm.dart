import 'package:ambulance_tracker/dashbord/availableAmbulance.dart';
import 'package:ambulance_tracker/registration/basic.dart';
import 'package:flutter/material.dart';
import 'package:ambulance_tracker/registration/userRegistration.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────
//  PATIENT DETAILS PAGE
// ─────────────────────────────────────────────────────────────
class patientDetailsForm extends StatefulWidget {
  const patientDetailsForm({super.key});

  @override
  State<patientDetailsForm> createState() => _patientDetailsFormState();
}

class _patientDetailsFormState extends State<patientDetailsForm> {
  // controllers
  final TextEditingController _numPatientsCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // dropdown choices
  final List<String> _bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
  ];

  bool _hasLocation = false;

  // dynamic lists that grow / shrink with patient count
  int _patientCount=1 ;
  List<TextEditingController> _nameCtrls = [TextEditingController()];
  List<TextEditingController> _ageCtrls = [TextEditingController()];
  List<String?> _bloodSelected = [null];

  // rebuild helpers
  void _rebuildLists(int count) {
    _patientCount = count;
    _nameCtrls = List.generate(count, (_) => TextEditingController());
    _ageCtrls = List.generate(count, (_) => TextEditingController());
    _bloodSelected = List.generate(count, (_) => null);
    setState(() {}); // ← trigger rebuild
  }

  // ───────────────── ui ─────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      // ------------ app bar ------------
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

      // ------------ gradient background ------------
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(159, 13, 55, 1),
              Color.fromRGBO(189, 83, 114, 1),
            ],
          ),
        ),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
          left: 10,
          right: 10,
          bottom: 10,
        ),

        // one single scrollable parent
        child: Container(
          // no fixed height → allows natural scrolling
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),

          // --- white card content ---
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Column(
                      children: [
                        // pink strip with profile icon
                        Container(
                          height: 76,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(227, 185, 197, 1),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                          alignment: Alignment.centerRight,
                          child: Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.person, size: 30),
                                onPressed: () {}, // TODO
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                        const Text(
                          'PATIENT DETAILS',
                          style: TextStyle(
                            color: Color.fromRGBO(87, 24, 44, 1),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // -------- number of patients --------
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "required *",
                              style: TextStyle(
                                color: Color.fromRGBO(87, 24, 44, 1),
                              ),
                            ),
                          ),
                        ),
                        CustomInputFieldNumber(
                          hintText: 'NUMBER OF PATIENTS',
                          controller: _numPatientsCtrl,
                          validator: (v) {
                            final n = int.tryParse(v ?? '');
                            if (n == null || n < 1) return 'Enter at least 1';
                            return null;
                          },
                          onChanged: (v) {
                            final c = int.tryParse(v);
                            if (c != null && c >= 0) _rebuildLists(c);
                          },
                        ),

                        const SizedBox(height: 30),

                        // -------- add location button --------
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(
                                  187,
                                  51,
                                  90,
                                  1,
                                ),
                                minimumSize: const Size(167, 42),
                              ),
                              onPressed: () {
                                setState(() => _hasLocation = true);
                                // TODO: actually open your map picker here
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text(
                                'ADD LOCATION',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                          const SizedBox(height: 50),

                        // -------- dynamic patient blocks --------
                        ...List.generate(
                          _patientCount,
                          (i) => Column(
                            children: [
                                // -------- patient details label --------
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 30),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'ADD PATIENT DETAILS',
                              style: TextStyle(
                                color: const Color.fromRGBO(87, 24, 44, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                    
                              CustomInputField(
                                hintText: 'NAME',
                                controller: _nameCtrls[i],
                              ),

                              const SizedBox(height: 20),

                              CustomInputFieldNumber(
                                hintText: 'AGE',
                                controller: _ageCtrls[i],
                              ),

                              const SizedBox(height: 20),

                              Container(
                                width: 325,
                                height: 66,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(227, 185, 197, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _bloodSelected[i],
                                    hint: const Padding(
                                      padding: EdgeInsets.only(left: 19),
                                      child: Text('BLOOD GROUP'),
                                    ),
                                    items:
                                        _bloodGroups
                                            .map(
                                              (bg) => DropdownMenuItem<String>(
                                                value: bg,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 19,
                                                      ),
                                                  child: Text(bg),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                    onChanged:
                                        (v) => setState(
                                          () => _bloodSelected[i] = v,
                                        ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),
                            ],
                          ),
                        ),

                        // -------- view ambulance button --------
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(159, 13, 55, 1),
                  minimumSize: const Size(265, 55),
                ),
                onPressed: () {
                final okInputs  = _formKey.currentState!.validate();
  final okLocation = _hasLocation;

  if (okInputs && okLocation) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AvailableAmbulance()),
    );
  } else {
    final msg = !okInputs
        ? 'Please complete required fields'
        : 'Please add a location';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: const Color.fromARGB(255, 158, 18, 8)),
    );
  }
                },
                child: const Text(
                  'VIEW AMBULANCE',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),

              const SizedBox(height: 23),
            ],
          ),
        ),
      ),
    );
  }
}

// Numeric text input (used for AGE & NUM OF PATIENTS)
class CustomInputFieldNumber extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const CustomInputFieldNumber({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325,
      height: 66,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(227, 185, 197, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(0, 0, 0, 42),
          ),
          contentPadding: const EdgeInsets.only(left: 19, top: 20),
        ),
      ),
    );
  }
}

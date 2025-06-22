// import 'package:ambulance_tracker/controller/profileControllerr

import 'package:ambulance_tracker/controller/profile_conrtoller.dart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserEdit extends StatelessWidget {
  UserEdit({super.key});

  final ctrl     = Get.put(EditProfileController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appBar(),
        body: Obx(() => ctrl.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : _form(context)),
      );

  /*————————— UI helpers —————————*/
  PreferredSizeWidget _appBar() => AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Image.asset('assets/title.png',
              fit: BoxFit.contain, height: 180),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      );

  Widget _form(BuildContext ctx) => _gradient(
        SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 120),
              _title(),
              const SizedBox(height: 50),
              _label('NAME:'),
              _text(ctrl.nameCtrl, 'NAME'),
              const SizedBox(height: 20),
              _label('PHONE NUMBER:'),
              _text(ctrl.phoneCtrl, 'PHONE NUMBER',
                  keyboard: TextInputType.phone),
              const SizedBox(height: 20),
              _label('DISTRICT:'),
              _district(),
              const SizedBox(height: 72),
              _updateBtn(),
            ]),
          ),
        ),
      );

  /*————————— styling wrappers —————————*/
  Widget _gradient(Widget child) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF9F0D37), Color(0xFFBD5372)]),
        ),
        padding: const EdgeInsets.fromLTRB(10, kToolbarHeight + 10, 10, 10),
        child: Container(
          height: double.infinity,
            decoration: BoxDecoration(
          
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: child),
      );

  Widget _title() => const Text('EDIT YOUR PROFILE',
      style: TextStyle(
          color: Color(0xFF57182C), fontSize: 32, fontWeight: FontWeight.bold));

  Widget _label(String t) =>
      Align(alignment: Alignment.centerLeft, child: Padding(
          padding: const EdgeInsets.only(left: 40), child: Text(t)));

  Widget _text(TextEditingController c, String hint,
          {TextInputType? keyboard}) =>
      Container(
        width: 325,
        height: 66,
        decoration: BoxDecoration(
            color: const Color(0xFFE3B9C5),
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          controller: c,
          keyboardType: keyboard,
          validator: (v) => v!.isEmpty ? 'Required' : null,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              contentPadding: const EdgeInsets.only(left: 19, top: 20)),
        ),
      );

  Widget _district() => Container(
        width: 325,
        height: 66,
        decoration: BoxDecoration(
            color: const Color(0xFFE3B9C5),
            borderRadius: BorderRadius.circular(10)),
        child: Obx(() => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: ctrl.district.value,
                hint: const Padding(
                    padding: EdgeInsets.only(left: 19), child: Text('DISTRICT')),
                items: _districts
                    .map((d) => DropdownMenuItem(
                        value: d,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 19),
                            child: Text(d))))
                    .toList(),
                onChanged: (v) => ctrl.district.value = v,
              ),
            )),
      );

  Widget _updateBtn() => ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) ctrl.save();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9F0D37),
          minimumSize: const Size(265, 55),
        ),
        child:
            const Text('UPDATE', style: TextStyle(fontSize: 24, color: Colors.white)),
      );

  /*————————— data —————————*/
  static const _districts = [
    'Thiruvananthapuram','Kollam','Pathanamthitta','Alappuzha','Kottayam','Idukki',
    'Ernakulam','Thrissur','Palakkad','Malappuram','Kozhikode','Wayanad','Kannur',
    'Kasaragod'
  ];
}

import 'package:ambulance_tracker/services/driver_profile_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/driver_model.dart';

class DriverEditController extends GetxController {
  // ── reactive state ──
  final loading = true.obs;

  // ── text controllers ──
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final vehNoCtrl = TextEditingController();
  final capacityCtrl = TextEditingController();
  final facilitiesCtrl = TextEditingController(); // comma‑string for UI

  // ── dropdown selections ──
  final district = RxnString();
  final sector = RxnString();
  final facilities = <String>[].obs;
  // keep ID so we can send it back
  late int driverId;

  final _srv = DriverProfileService();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      final d = await _srv.fetch();
 
      driverId = d.id;
      nameCtrl.text = d.name ?? '';
      phoneCtrl.text = d.phoneno ?? '';
      vehNoCtrl.text = d.vehicleno ?? '';
      capacityCtrl.text = d.capacity ?? '';
      facilities.assignAll(d.facilities ?? []);
 
      facilitiesCtrl.text = facilities.join(', ');
     
      district.value = d.district;
      sector.value = d.sector;
    } catch (e) {
      loading.value = false;
      Get.snackbar('Load failed', e.toString());
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  Future<void> save() async {
    loading.value = true;
    try {
      await _srv.update(
        Driver(
         id: driverId,
          name: nameCtrl.text.trim(),
          phoneno: phoneCtrl.text.trim(),
          vehicleno: vehNoCtrl.text.trim(),
          sector: sector.value ?? '',
          capacity: capacityCtrl.text.trim(),
          district: district.value ?? '',
          facilities:
              facilitiesCtrl.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
        ),
      );
      Get.back();
      Get.snackbar('Success', 'Profile updated');
    } catch (e) {
      // Get.snackbar('Error', e.toString());
    
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    vehNoCtrl.dispose();
    capacityCtrl.dispose();
    facilitiesCtrl.dispose();
    super.onClose();
  }
}

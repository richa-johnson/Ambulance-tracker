import 'package:ambulance_tracker/dashbord/userdashbordScreen.dart';
import 'package:ambulance_tracker/models/user.dart';
import 'package:ambulance_tracker/services/profile_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final _service = ProfileService();

  // text controllers bound to the form fields
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final district = RxnString(); // holds the drop-down value

  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      final user = await _service.fetch();
      nameCtrl.text = user['user_name'] ?? '';
      phoneCtrl.text = user['user_phone'] ?? '';
      district.value = user['user_district'];
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> save() async {
    isLoading.value = true;
    try {
      await _service.update(
        User(
          name: nameCtrl.text.trim(),
          phone: phoneCtrl.text.trim(),
          district: district.value,
        ),
      );

      Get.snackbar('Success', 'Profile updated');
      Get.off(() => const userdashboard());
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print( e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}

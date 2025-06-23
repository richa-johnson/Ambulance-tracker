import 'dart:async';
import 'package:ambulance_tracker/services/booking_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/booking.dart';

enum DriverStatus { available, unavailable, busy }

class DriverBookingController extends GetxController {
   final bool _isDriver;

  DriverBookingController(this._isDriver);

  final showConfirmation = false.obs;
  final bookings = <Booking>[].obs;
  final _service = BookingService();
  Timer? _timer;
  final status = DriverStatus.unavailable.obs;

  final confirmingIds = <int>{}.obs; // only for confirm spinners
  final cancellingIds = <int>{}.obs; // only for cancel spinners
  // ──────────────────────────────────
  final isBusy = false.obs;

    final _incoming      = Rxn<Booking>();            // ★ NEW: one-slot “inbox”
  int?  _lastNotifiedId;   

  @override
   void onReady() {        // ← runs after the first frame of *any* widget
    super.onReady(); 
     if (_isDriver) {
      _checkAvailabilityFromServer(); 
      ever(_incoming, _showAlert);   // only drivers will start polling
    }
  }

  void _checkAvailabilityFromServer() async {
    final isAvailable = await _service.fetchAvailability(); // implement this
    status.value =
        isAvailable ? DriverStatus.available : DriverStatus.unavailable;

    if (isAvailable) {
      startPolling();
    }
  }

  void startPolling() {
    if (_timer != null) return; // already polling
     if (!_isDriver) return;
    _poll(); // immediate fetch
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _poll());
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _poll() async {
     if (!_isDriver) return; 
    

    if (status.value != DriverStatus.available) {
     
      return;
    }
    try {
      final list = await _service.getPendingBookings();

    
      bookings.assignAll(list); // keep existing assignment

       if (list.isNotEmpty && list.first.id != _lastNotifiedId) {
      _incoming.value = list.first;           // triggers ever() → dialog
      _lastNotifiedId = list.first.id;        // remember it
    }
      
    } catch (e, st) {
      print('❌ _poll error: $e');
      print(st);
    }
  }

  Future<void> confirm(int id) async {
    confirmingIds.add(id); // start spinner on Confirm btn
    try {
      await _service.confirm(id);

      status.value = DriverStatus.busy;
      stopPolling();

      bookings.assignAll(bookings.where((b) => b.id == id));
      bookings.refresh();

      showConfirmation.value = true;
      Future.delayed(const Duration(seconds: 5), () {
        showConfirmation.value = false;
      });
    } catch (e) {
      Get.snackbar('Error', 'Could not confirm booking');
    }
  }

  Future<void> cancel(int id) async {
    cancellingIds.add(id);
    try {
      await _service.cancel(id); // 2️⃣ backend call
      bookings.removeWhere((b) => b.id == id);
    } catch (e) {
      cancellingIds.remove(id); // rollback only on failure
      Get.snackbar('Error', 'Could not cancel booking');
    }
  }

  /// Called when the driver taps “End Ride”
  Future<void> completeRide(int bookingId) async {
    try {
      await _service.completeRide(bookingId); // backend endpoint
      status.value = DriverStatus.available; // free to take jobs again
      startPolling(); // resume polling
    } catch (e) {
      Get.snackbar('Error', 'Could not complete ride');
    }
  }
    void _showAlert(Booking? b) {
    if (b == null) return;
    _incoming.value = null;                         // reset immediately

    Get.dialog(
      AlertDialog(
        title: const Text('New patient request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('User: ${b.userName}'),
            Text('Patient Count : ${b.pCount}'),
            Text('Location: ${b.pLocation}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await cancel(b.id);
              Get.back();                           // close dialog
            },
            child: const Text('Reject'),
          ),
          ElevatedButton(
            onPressed: () async {
              await confirm(b.id);
              Get.back();                           // close dialog
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
     print('🔥 DriverBookingController disposed');
    _timer?.cancel();
     _timer = null;
    super.onClose();
  }
}

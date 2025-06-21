import 'dart:async';
import 'package:ambulance_tracker/services/booking_services.dart';
import 'package:get/get.dart';
import '../models/booking.dart';

enum DriverStatus { available, unavailable, busy }

class DriverBookingController extends GetxController {

DriverBookingController() {
    print('🚀 DriverBookingController CREATED');
  }

  final bookings = <Booking>[].obs;
  final _service = BookingService();
  Timer? _timer;
   final status   = DriverStatus.unavailable.obs;
 
   final confirmingIds = <int>{}.obs;          // only for confirm spinners
  final cancellingIds = <int>{}.obs;          // only for cancel spinners
  // ──────────────────────────────────
   final isBusy = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('🟢 onInit called');
    _checkAvailabilityFromServer(); 
  }
void _checkAvailabilityFromServer() async {
    final isAvailable = await _service.fetchAvailability(); // implement this
    status.value = isAvailable ? DriverStatus.available : DriverStatus.unavailable;

    if (isAvailable) {
      startPolling();
    }
  }
 void startPolling() {
    if (_timer != null) return;              // already polling
    _poll();                                 // immediate fetch
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _poll(),
    );
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;

  }
  Future<void> _poll() async {
   
   if (status.value != DriverStatus.available ) return;
    try {
      final list = await _service.getPendingBookings().timeout(
        const Duration(seconds: 8),
      );
      ;
      // print('🔵 Service returned: ${list.length} items');
      bookings.assignAll(list); // keep existing assignment
      // print('🟢 bookings list now: ${bookings.length}');
    } catch (e, st) {
      // print('❌ _poll error: $e');
      // print(st);
    }
  }

  Future<void> confirm(int id) async {
    confirmingIds.add(id);                    // start spinner on Confirm btn
    try {
      await _service.confirm(id);

       status.value = DriverStatus.busy;
      stopPolling();

        
          bookings.assignAll(bookings.where((b) => b.id == id));
    
    } catch (e) {
                            
      Get.snackbar('Error', 'Could not confirm booking');
    } 
  }
Future<void> cancel(int id) async {
  cancellingIds.add(id); 
  try {
    await _service.cancel(id);    // 2️⃣ backend call
    bookings.removeWhere((b) => b.id == id);
  } catch (e) {
   cancellingIds.remove(id);          // rollback only on failure
    Get.snackbar('Error', 'Could not cancel booking');
  }
  // ← no finally block
}


  /// Called when the driver taps “End Ride”
  Future<void> completeRide(int bookingId) async {
    try {
      await _service.completeRide(bookingId); // backend endpoint
      status.value = DriverStatus.available;  // free to take jobs again
      startPolling();                         // resume polling
    } catch (e) {
      Get.snackbar('Error', 'Could not complete ride');
    }
  }
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

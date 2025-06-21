import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../models/booking.dart';
import '../controller/driver_booking_controller.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final DriverBookingController ctrl = Get.find();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'New Booking',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('User: ${booking.userName}'),
            Text('Phone: ${booking.userPhone}'),
            Text('No. of Patients: ${booking.pCount}'),
            Text('Location: ${booking.pLocation}'),
            const SizedBox(height: 12),
            Obx(() {
              final confirmBusy = ctrl.confirmingIds.contains(booking.id);
              final cancelBusy = ctrl.cancellingIds.contains(booking.id);

              Widget busyIcon(Color color) => const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              );

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: confirmBusy ? null : onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child:
                        confirmBusy ? busyIcon(Colors.white) : const Text('Confirm'),
                  ),
                  ElevatedButton(
                    onPressed:  cancelBusy ? null : onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: cancelBusy ? busyIcon(Colors.white) : const Text('Cancel'),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

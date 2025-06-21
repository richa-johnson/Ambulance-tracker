// lib/screens/driver_dashboard.dart
import 'package:ambulance_tracker/alerts/booking_card.dart';
import 'package:ambulance_tracker/controller/driver_booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    // 🔑 Put the controller once so it survives hot reloads
    final ctrl = Get.put(DriverBookingController(), permanent: true);

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

      // ——— Gradient background identical to your RequestsPage ———
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(159, 13, 55, 1.0),
              Color.fromRGBO(189, 83, 114, 1.0),
            ],
          ),
        ),

        // Push content below the translucent AppBar
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
          left: 10,
          right: 10,
          bottom: 10,
        ),

        // ——— White container that holds the scroll view ———
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Obx(() {
            // Reactive part – updates every 10 s via the controller
      

            if (ctrl.bookings.isEmpty) {
              return const Center(
                child: Text(
                  'No pending bookings',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: ctrl.bookings.length,
              itemBuilder: (context, i) {
                final b = ctrl.bookings[i];
                return BookingCard(
                  booking: b,
                  onConfirm: () => ctrl.confirm(b.id),
                  onCancel: () => ctrl.cancel(b.id),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

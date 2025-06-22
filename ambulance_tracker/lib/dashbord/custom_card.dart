import 'dart:convert';
import 'dart:async';
import 'package:ambulance_tracker/constant.dart';
import 'package:ambulance_tracker/dashbord/userdashbordScreen.dart';
import 'package:ambulance_tracker/models/driver_model.dart';
import 'package:ambulance_tracker/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomCard extends StatefulWidget {
  final Driver driver;
  final String pickupLocation;
  final int patientCount;
  final List<Map<String, dynamic>> patientList;
  final ValueNotifier<bool> bookingLocked;
  final void Function(Map<String, dynamic> result)? onBookingResult;

  const CustomCard({
    Key? key,
    required this.driver,
    required this.pickupLocation,
    required this.patientCount,
    required this.patientList,
    required this.bookingLocked,
    this.onBookingResult,
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  Timer? countdownTimer;
  Timer? statusCheckTimer;

  int remainingSeconds = 120;
  String bookingStatus = 'pending';

  int? currentBookingId;

  bool isPressed = false; // this card’s button is now green/locked
  bool isSubmitting = false; // show spinner while waiting
  final ValueNotifier<bool> bookingExpiredHandled = ValueNotifier(false);

  @override
  void dispose() {
    countdownTimer?.cancel();
    statusCheckTimer?.cancel();
    super.dispose();
  }

  void startBookingTimer(int bookingId, int driverId) {
    countdownTimer?.cancel();
    statusCheckTimer?.cancel();

    if (!mounted) return;

    setState(() {
      currentBookingId = bookingId;
      remainingSeconds = 120;
      bookingStatus = 'pending';
      bookingExpiredHandled.value = false;
    });

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timer.cancel();
          expireBooking();
        }
      });
    });

    statusCheckTimer = Timer.periodic(Duration(seconds: 5), (_) async {
      if (bookingExpiredHandled.value) return;

      final token = await getToken();
      final url = Uri.parse('$baseURL/booking/$bookingId/status');

      final res = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        String status = data['status'];

        if (status != 'pending') {
          countdownTimer?.cancel();
          statusCheckTimer?.cancel();

          if (!mounted) return;

          setState(() {
            bookingStatus = status;
            bookingExpiredHandled.value = true;
          });

          if (status == 'confirmed') {
            countdownTimer?.cancel();
            statusCheckTimer?.cancel();
            if (!mounted) return;
            setState(() {
              bookingStatus = status;
              bookingExpiredHandled.value = true;
            });

            Future.microtask(() {
              if (!mounted) return;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => AlertDialog(
                      title: Text('✅ Booking Confirmed'),
                      content: Text('Driver has accepted your request.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (!mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => userdashboard(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text('OK'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (mounted) Navigator.of(context).pop();
                            // TODO: Track driver logic
                          },
                          child: Text('Track Driver'),
                        ),
                      ],
                    ),
              );
            });
          } else if (status == 'cancelled') {
            countdownTimer?.cancel();
            statusCheckTimer?.cancel();
            if (!mounted) return;
            setState(() {
              bookingStatus = status;
              bookingExpiredHandled.value = true;
            });

            if (widget.onBookingResult != null) {
              widget.onBookingResult!({'driverId': driverId, 'expired': true});
            }

            Future.microtask(() {
              if (!mounted) return;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => AlertDialog(
                      title: Text('❌ Booking Cancelled'),
                      content: Text(
                        'Driver rejected the request. Please try another.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (widget.onBookingResult != null) {
                              widget.onBookingResult!({'refresh': true});
                            }
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
              );
            });
          }
        }
      }
    });
  }


  Future<void> expireBooking() async {
    final token = await getToken();
    final url = Uri.parse('$baseURL/booking/check-expiry');

    final res = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['b_status'] == 'expired') {
        print('✅ Booking expired on server.');

        // ❗ Stop timers
        countdownTimer?.cancel();
        statusCheckTimer?.cancel();

        if (!mounted) return;
        setState(() {
          bookingStatus = 'expired';
          bookingExpiredHandled.value = true;
        });

        if (widget.onBookingResult != null) {
          widget.onBookingResult!({
            'driverId': data['driver_id'],
            'expired': true,
          });
        }

        if (!mounted) return;
        Future.microtask(() {
          if (!mounted) return;
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('⏱️ Booking Expired'),
                  content: const Text(
                    'Driver did not respond in time. Please try another ambulance.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        });
      } else {
        print('ℹ️ Booking is still active: ${data['b_status']}');
      }
    } else {
      print('❌ Expire check failed: ${res.body}');
    }
  }

  Future<int> _createBooking(String token) async {
    final res = await http.post(
      Uri.parse('$baseURL/booking/store'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'driver_id': widget.driver.id,
        'p_location': widget.pickupLocation,
        'p_count': widget.patientCount,
      }),
    );
    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      int bookingId = data['booking_id'];
      startBookingTimer(bookingId, widget.driver.id);
      return bookingId;
    }else{
      throw Exception("Booking failed: ${res.body}");
    }
  }

  Future<void> _sendPatients(String token, int bookingId) async {
    final res = await http.post(
      Uri.parse('$baseURL/booking/$bookingId/patients'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'patients': widget.patientList}),
    );
    if (res.statusCode != 200 &&
    res.statusCode != 201 &&
    res.statusCode != 204) {
  throw Exception('Patient upload failed: ${res.body}');
}

 }


  

  Future<void> _bookDriver() async {
    setState(() => isSubmitting = true);

    try {
      final token = await getToken();
      final bookingId = await _createBooking(token);
      await _sendPatients(token, bookingId);
      if (bookingId != null) {
        setState(() => isPressed = true);
        widget.bookingLocked.value = true; // lock every card
        ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking successful!")),
    );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Booking failed: $e')));
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.driver;

    return Card(
      margin: const EdgeInsets.all(12),
      color: const Color(0xFF9F0D37),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              d.name,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.white, size: 18),
                const SizedBox(width: 5),
                Text(
                  d.phoneno,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 25),
                Text(
                  d.vehicleno,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const Spacer(),
                ValueListenableBuilder<bool>(
                  valueListenable: widget.bookingLocked,
                  builder: (_, locked, __) {
                    final disabled = isPressed || locked || isSubmitting;
                    return ElevatedButton(
                      onPressed: disabled ? null : _bookDriver,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isPressed ? Colors.green : Colors.white,
                        minimumSize: const Size(100, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child:
                          isSubmitting
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                isPressed ? 'Request Sent' : 'Book Now',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isPressed
                                          ? Colors.white
                                          : const Color(0xFF9F0D37),
                                ),
                              ),
                    );
                  },
                ),
              ],
            ),
            if (currentBookingId != null && bookingStatus == 'pending') ...[
              Text(
                '⏳ Time left: ${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 8),
            Container(height: 1, color: const Color(0xFFE7A4A4), width: 300),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFE7A4A4),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder:
                          (_) => _DriverDetailsSheet(
                            name: d.name,
                            sector: d.sector,
                            district: d.disrtict ?? '',
                            capacity: d.capacity,
                            facilities: d.facilities,
                          ),
                    );
                  },
                  child: const Text('View More'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
  

class _DriverDetailsSheet extends StatelessWidget {
  final String name;
  final String district;
  final String capacity;
  final String sector;
  final List<String> facilities;

  const _DriverDetailsSheet({
    required this.name,
    required this.district,
    required this.capacity,
    required this.facilities,
    required this.sector,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 3,
                color: const Color.fromARGB(115, 110, 108, 108),
              ),
              const SizedBox(height: 5),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9F0D37),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sector : $sector',
                      style: const TextStyle(
                        color: Color(0xFF9F0D37),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Capacity: $capacity',
                      style: const TextStyle(
                        color: Color(0xFF9F0D37),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Facilities',
                      style: TextStyle(
                        color: Color(0xFF9F0D37),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...facilities.map(
                      (f) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '• $f',
                          style: const TextStyle(
                            color: Color(0xFF9F0D37),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  
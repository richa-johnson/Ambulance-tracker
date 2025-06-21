class Booking {
   final int id;               // book_id in backend
  final int driverId;
  final int userId;
  final String pLocation;     // p_location
  final int pCount;           // p_count
  final String status;        // b_status
  final String createdAt;
  final String? endTime;
  final String userName;      // nested user.name
  final String userPhone;     // nested user.phone

  Booking({
       required this.id,
    required this.driverId,
    required this.userId,
    required this.pLocation,
    required this.pCount,
    required this.status,
    required this.createdAt,
    required this.endTime,
    required this.userName,
    required this.userPhone,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
         id: json['book_id'],                // <-- map correctly
      driverId: json['driver_id'],
      userId: json['user_id'],
      pLocation: json['p_location'],
      pCount: json['p_count'],
      status: json['b_status'],
      createdAt: json['created_at'],
      endTime: json['end_time'],
      userName: json['user']?['name'] ?? 'Unknown',
      userPhone: json['user']?['phone'] ?? 'N/A',
      );
}

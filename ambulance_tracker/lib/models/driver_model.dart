class Driver {
  final int id;
  final String name;
  final String phoneno;
  final String vehicleno;
  final String sector;
  final int capacity;
  final List<String> facilities;

  Driver({
    required this.id,
    required this.name,
    required this.phoneno,
    required this.vehicleno,
    required this.sector,
    required this.capacity,
    required this.facilities,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['driver_id'],
      name: json['name'],
      phoneno: json['phoneno'],
      vehicleno: json['vehicleno'],
      sector: json['sector'],
      capacity: json['capacity'],
      facilities: List<String>.from(json['facilities'] ?? []),
    );
  }
}

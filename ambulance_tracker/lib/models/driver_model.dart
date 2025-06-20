class Driver {
  final int id;
  final String name;
  final String phoneno;
  final String vehicleno;
  final String sector;
  final String capacity;
  final String disrtict;
  final List<String> facilities;

  Driver({
    required this.id,
    required this.name,
    required this.phoneno,
    required this.vehicleno,
    required this.sector,
    required this.capacity,
    required this.disrtict,
    required this.facilities,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    final rawId = json['slno'];
    return Driver(
      id: int.parse(rawId.toString()),
      name: json['name'],
      phoneno: json['phoneno'],
      vehicleno: json['vehicleno'],
      disrtict: json['district'],
      sector: json['sector'],
       capacity: json['capacity']?.toString() ?? '',
      facilities: List<String>.from(json['facilities'] ?? []),
    );
  }
}

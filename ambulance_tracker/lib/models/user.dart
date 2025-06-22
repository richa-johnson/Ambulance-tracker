class User {
  int? id;
  String? name;
  String? email;
   String? phone;
  String? district;

  String? token;
  String? role;

  User({this.id, this.name, this.email, this.phone,
    this.district,this.token, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'],
      name: json['user_name'],
      email: json['user_mail'],
      phone:    json['user_phone'],
        district: json['user_district'],
      
    );

    
  }
  Map<String, dynamic> toJson() => {
        'name'     : name,
        'phone'    : phone,
        'district' : district,
      };


}

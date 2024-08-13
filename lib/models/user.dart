import 'package:intl/intl.dart';

class User {
  final String? name;
  final String? email;
  final String? password;
  final String? address;
  final DateTime? dob;
  final String? gender;
  final String? phone;
  final String? avatar;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.dob,
    this.address,
    this.gender,
    this.phone,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      address: json['address'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      gender: json['gender'],
      phone: json['phone'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'phone': phone,
      'avatar': avatar,
    };
  }

  String? get formattedDob {
    if (dob == null) return null;
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dob!);
  }
}

import 'dart:convert';

class User {
  final String email;
  final String avatar;
  final String name;
  final String gender;
  final String phone;

  User(
      {required this.email,
      required this.avatar,
      required this.name,
      required this.gender,
      required this.phone});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'avatar': avatar,
      'name': name,
      'gender': gender,
      'phone': phone,
    };
  }

}

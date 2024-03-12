import 'package:bcrypt/bcrypt.dart';

class User {
  final int? id;
  final String username;
  final String mail;
  final String password;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    this.id,
    required this.username,
    required this.mail,
    required this.password,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'mail': mail,
      'password': password,
      'isActive': isActive ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      mail: map['mail'],
      password: map['password'],
      isActive: map['isActive'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Future<bool> verifyPassword(String password) async {
    return BCrypt.checkpw(password, this.password);
  }
}
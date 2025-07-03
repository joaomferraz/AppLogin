// lib/models/user_model.dart
class UserModel {
  final int? id;
  final String email;
  final String password;
  final String name;

  UserModel({this.id, required this.email, required this.password, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      name: map['name'],
    );
  }
}

import 'package:equatable/equatable.dart';

enum UserRole { user, partner, admin }

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final UserRole role;
  final String gender;
  final String? image;
  final String? locale;
  final DateTime createdAt;
  final String? token;

  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    required this.gender,
    this.image,
    this.locale,
    required this.createdAt,
    this.token,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        email,
        phone,
        role,
        gender,
        image,
        locale,
        createdAt,
        token,
      ];
}


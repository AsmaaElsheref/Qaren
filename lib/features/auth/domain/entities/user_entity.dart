import 'package:equatable/equatable.dart';

enum UserRole { user, partner, admin }

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? token;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.token,
  });

  @override
  List<Object?> get props => [id, email, name, role, token];
}


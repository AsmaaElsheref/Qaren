import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.username,
    required super.email,
    required super.phone,
    required super.role,
    required super.gender,
    super.image,
    super.locale,
    required super.createdAt,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    return UserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.user,
      ),
      gender: json['gender'] as String? ?? '',
      image: json['image'] as String?,
      locale: json['locale'] as String?,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      token: token ?? json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'role': role.name,
      'gender': gender,
      'image': image,
      'locale': locale,
      'created_at': createdAt.toIso8601String(),
      'token': token,
    };
  }
}



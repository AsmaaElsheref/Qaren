import 'package:equatable/equatable.dart';

class UpdateProfileParams extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String? password;
  final String? passwordConfirmation;
  final String? imagePath;

  const UpdateProfileParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.password,
    this.passwordConfirmation,
    this.imagePath,
  });

  Map<String, dynamic> toFields() {
    final fields = <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
    };

    if (password != null && password!.isNotEmpty) {
      fields['password'] = password;
      fields['password_confirmation'] = passwordConfirmation ?? '';
    }

    return fields;
  }

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        gender,
        password,
        passwordConfirmation,
        imagePath,
      ];
}


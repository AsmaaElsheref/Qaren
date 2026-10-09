import 'package:equatable/equatable.dart';

class UpdateProfileParams extends Equatable {
  final String name;
  final String email;
  final String? password;
  final String? passwordConfirmation;
  final String? imagePath;

  const UpdateProfileParams({
    required this.name,
    required this.email,
    this.password,
    this.passwordConfirmation,
    this.imagePath,
  });

  Map<String, dynamic> toFields() {
    final fields = <String, dynamic>{'name': name, 'email': email};

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
    password,
    passwordConfirmation,
    imagePath,
  ];
}

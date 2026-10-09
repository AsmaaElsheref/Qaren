import 'package:equatable/equatable.dart';

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  /// Local file path of the selected avatar image. Null if not provided.
  final String? imagePath;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.imagePath,
  });

  /// Returns the plain-text fields only.
  /// The [imagePath] is handled separately as a multipart file in the
  /// data source layer via [FormData].
  Map<String, dynamic> toFields() {
    return {
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
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

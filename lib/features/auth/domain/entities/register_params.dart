import 'package:equatable/equatable.dart';

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;
  final String gender;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.phone,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone': phone,
        'gender': gender,
      };

  @override
  List<Object> get props =>
      [name, email, password, passwordConfirmation, phone, gender];
}


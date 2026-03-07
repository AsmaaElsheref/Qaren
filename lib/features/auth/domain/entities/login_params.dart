import 'package:equatable/equatable.dart';

enum UserTypeTab { user, partner, admin }

extension UserTypeTabExtension on UserTypeTab {
  String get label {
    switch (this) {
      case UserTypeTab.user:
        return 'مستخدم';
      case UserTypeTab.partner:
        return 'شريك';
      case UserTypeTab.admin:
        return 'إدارة';
    }
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;
  final UserTypeTab userType;

  const LoginParams({
    required this.email,
    required this.password,
    required this.userType,
  });

  @override
  List<Object> get props => [email, password, userType];
}


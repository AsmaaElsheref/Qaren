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
  final String login;
  final String password;
  final UserTypeTab userType;

  const LoginParams({
    required this.login,
    required this.password,
    required this.userType,
  });

  Map<String, dynamic> toJson() => {
        'login': login,
        'password': password,
      };

  @override
  List<Object> get props => [login, password, userType];
}


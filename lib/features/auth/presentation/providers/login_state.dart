import 'package:equatable/equatable.dart';
import '../../domain/entities/login_params.dart';
import '../../domain/entities/user_entity.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final UserTypeTab selectedUserType;
  final bool isPasswordVisible;
  final UserEntity? user;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.selectedUserType = UserTypeTab.user,
    this.isPasswordVisible = false,
    this.user,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    UserTypeTab? selectedUserType,
    bool? isPasswordVisible,
    UserEntity? user,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      selectedUserType: selectedUserType ?? this.selectedUserType,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedUserType,
        isPasswordVisible,
        user,
        errorMessage,
      ];
}


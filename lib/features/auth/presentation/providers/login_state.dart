import 'package:equatable/equatable.dart';
import '../../domain/entities/login_params.dart';
import '../../domain/entities/user_entity.dart';

enum LoginStatus { initial, loading, success, failure }

enum LoginMethod { password, google, biometric }

class LoginState extends Equatable {
  final LoginStatus status;
  final UserTypeTab selectedUserType;
  final bool isPasswordVisible;
  final UserEntity? user;
  final String? errorMessage;
  final bool showBiometricPrompt;
  final LoginMethod? activeMethod;

  const LoginState({
    this.status = LoginStatus.initial,
    this.selectedUserType = UserTypeTab.user,
    this.isPasswordVisible = false,
    this.user,
    this.errorMessage,
    this.showBiometricPrompt = false,
    this.activeMethod,
  });

  static const _notProvided = Object();

  LoginState copyWith({
    LoginStatus? status,
    UserTypeTab? selectedUserType,
    bool? isPasswordVisible,
    UserEntity? user,
    String? errorMessage,
    bool? showBiometricPrompt,
    Object? activeMethod = _notProvided,
  }) {
    return LoginState(
      status: status ?? this.status,
      selectedUserType: selectedUserType ?? this.selectedUserType,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      user: user ?? this.user,
      errorMessage: errorMessage,
      showBiometricPrompt: showBiometricPrompt ?? this.showBiometricPrompt,
      activeMethod: identical(activeMethod, _notProvided)
          ? this.activeMethod
          : activeMethod as LoginMethod?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedUserType,
    isPasswordVisible,
    user,
    errorMessage,
    showBiometricPrompt,
    activeMethod,
  ];
}

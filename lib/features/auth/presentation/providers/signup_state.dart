import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState extends Equatable {
  final SignupStatus status;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String selectedGender;
  final String? imagePath;
  final UserEntity? user;
  final String? errorMessage;

  const SignupState({
    this.status = SignupStatus.initial,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.selectedGender = 'male',
    this.imagePath,
    this.user,
    this.errorMessage,
  });

  SignupState copyWith({
    SignupStatus? status,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    String? selectedGender,
    String? imagePath,
    bool clearImage = false,
    UserEntity? user,
    String? errorMessage,
  }) {
    return SignupState(
      status: status ?? this.status,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      selectedGender: selectedGender ?? this.selectedGender,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isPasswordVisible,
        isConfirmPasswordVisible,
        selectedGender,
        imagePath,
        user,
        errorMessage,
      ];
}


import 'package:equatable/equatable.dart';

import '../../../../auth/domain/entities/user_entity.dart';

enum EditProfileStatus { initial, loading, success, failure }

class EditProfileState extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String password;
  final String passwordConfirmation;
  final String? imagePath;
  final String? currentImageUrl;
  final EditProfileStatus status;
  final String? errorMessage;
  final UserEntity? updatedUser;

  const EditProfileState({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.password = '',
    this.passwordConfirmation = '',
    this.imagePath,
    this.currentImageUrl,
    this.status = EditProfileStatus.initial,
    this.errorMessage,
    this.updatedUser,
  });

  factory EditProfileState.fromUser(UserEntity user) {
    return EditProfileState(
      name: user.name,
      email: user.email,
      phone: user.phone,
      gender: user.gender.isEmpty ? 'male' : user.gender,
      currentImageUrl: user.image,
    );
  }

  bool get hasSelectedImage => imagePath != null && imagePath!.isNotEmpty;
  bool get isLoading => status == EditProfileStatus.loading;

  EditProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? password,
    String? passwordConfirmation,
    String? imagePath,
    bool clearImage = false,
    String? currentImageUrl,
    EditProfileStatus? status,
    String? errorMessage,
    UserEntity? updatedUser,
  }) {
    return EditProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      passwordConfirmation:
          passwordConfirmation ?? this.passwordConfirmation,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      currentImageUrl: currentImageUrl ?? this.currentImageUrl,
      status: status ?? this.status,
      errorMessage: errorMessage,
      updatedUser: updatedUser ?? this.updatedUser,
    );
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
        currentImageUrl,
        status,
        errorMessage,
        updatedUser,
      ];
}


import '../../domain/entities/login_params.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(LoginParams params);
  Future<void> loginWithBiometrics(UserTypeTab userType);
  Future<void> forgotPassword(String email);
}

/// Mock implementation – replace with actual API calls
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(LoginParams params) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Demo: accept any non-empty credentials
    if (params.email.isNotEmpty && params.password.length >= 6) {
      return UserModel(
        id: 'usr_001',
        email: params.email,
        name: 'مستخدم قارن',
        role: _mapUserType(params.userType),
        token: 'mock_jwt_token_xyz',
      );
    }

    throw Exception('Invalid credentials');
  }

  @override
  Future<void> loginWithBiometrics(UserTypeTab userType) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  UserRole _mapUserType(UserTypeTab type) {
    switch (type) {
      case UserTypeTab.admin:
        return UserRole.admin;
      case UserTypeTab.partner:
        return UserRole.partner;
      case UserTypeTab.user:
        return UserRole.user;
    }
  }
}

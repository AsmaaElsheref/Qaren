import 'package:flutter_test/flutter_test.dart';
import 'package:qaren/features/auth/domain/entities/register_params.dart';

void main() {
  group('RegisterParams.toFields', () {
    test('serializes only supported registration fields', () {
      const params = RegisterParams(
        name: ' John Doe ',
        email: ' user@example.com ',
        password: 'SecurePassword123!',
        passwordConfirmation: 'SecurePassword123!',
      );

      expect(params.toFields(), {
        'name': 'John Doe',
        'email': 'user@example.com',
        'password': 'SecurePassword123!',
        'password_confirmation': 'SecurePassword123!',
      });
    });

    test('does not include phone or gender in the registration payload', () {
      const params = RegisterParams(
        name: 'John Doe',
        email: 'user@example.com',
        password: 'SecurePassword123!',
        passwordConfirmation: 'SecurePassword123!',
      );

      expect(params.toFields(), isNot(contains('phone')));
      expect(params.toFields(), isNot(contains('gender')));
    });
  });
}

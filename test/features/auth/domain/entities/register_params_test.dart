import 'package:flutter_test/flutter_test.dart';
import 'package:qaren/features/auth/domain/entities/register_params.dart';

void main() {
  group('RegisterParams.toFields', () {
    test('omits optional phone and gender when empty', () {
      const params = RegisterParams(
        name: ' John Doe ',
        email: ' user@example.com ',
        password: 'SecurePassword123!',
        passwordConfirmation: 'SecurePassword123!',
        phone: '   ',
      );

      expect(params.toFields(), {
        'name': 'John Doe',
        'email': 'user@example.com',
        'password': 'SecurePassword123!',
        'password_confirmation': 'SecurePassword123!',
      });
    });

    test('serializes trimmed optional phone and gender when supplied', () {
      const params = RegisterParams(
        name: 'John Doe',
        email: 'user@example.com',
        password: 'SecurePassword123!',
        passwordConfirmation: 'SecurePassword123!',
        phone: ' 0500000000 ',
        gender: ' male ',
      );

      expect(params.toFields()['phone'], '0500000000');
      expect(params.toFields()['gender'], 'male');
    });
  });
}

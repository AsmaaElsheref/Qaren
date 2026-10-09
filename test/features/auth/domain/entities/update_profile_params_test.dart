import 'package:flutter_test/flutter_test.dart';
import 'package:qaren/features/auth/domain/entities/update_profile_params.dart';

void main() {
  test('does not include phone or gender in the update payload', () {
    const params = UpdateProfileParams(
      name: 'John Doe',
      email: 'john@example.com',
    );

    expect(params.toFields(), {
      'name': 'John Doe',
      'email': 'john@example.com',
    });
  });
}

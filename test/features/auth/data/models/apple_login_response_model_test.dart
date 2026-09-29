import 'package:flutter_test/flutter_test.dart';
import 'package:qaren/features/auth/data/models/apple_login_response_model.dart';

void main() {
  test('parses a valid Apple Sanctum login response', () {
    final response = AppleLoginResponseModel.fromJson({
      'success': true,
      'data': {
        'user': {
          'id': 15,
          'name': 'Ahmed Mohamed',
          'username': 'ahmed-mohamed',
          'email': 'user@privaterelay.appleid.com',
          'role': 'user',
          'created_at': '2026-09-29T14:10:00.000000Z',
        },
        'token': '1|apple-sanctum-token',
      },
    });

    expect(response.success, isTrue);
    expect(response.data.user.id, 15);
    expect(response.data.user.name, 'Ahmed Mohamed');
    expect(response.data.user.token, '1|apple-sanctum-token');
  });

  test('rejects an Apple response without a Sanctum token', () {
    expect(
      () => AppleLoginResponseModel.fromJson({
        'success': true,
        'data': {
          'user': {
            'id': 15,
            'name': 'Ahmed Mohamed',
            'username': 'ahmed-mohamed',
            'email': 'user@privaterelay.appleid.com',
            'role': 'user',
            'created_at': '2026-09-29T14:10:00.000000Z',
          },
        },
      }),
      throwsA(isA<AppleLoginResponseException>()),
    );
  });
}

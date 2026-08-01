import 'package:flutter_test/flutter_test.dart';
import 'package:qaren/features/auth/data/models/google_login_response_model.dart';

void main() {
  group('GoogleLoginResponseModel', () {
    test('parses a valid Sanctum login response', () {
      final response = GoogleLoginResponseModel.fromJson({
        'success': true,
        'data': {
          'user': {
            'id': 1,
            'name': 'Test User',
            'email': 'test@example.com',
            'avatar': 'https://example.com/avatar.png',
          },
          'token': '1|sanctum-token',
        },
      });

      expect(response.success, isTrue);
      expect(response.data.token, '1|sanctum-token');
      expect(response.data.user.email, 'test@example.com');
      expect(response.data.user.image, 'https://example.com/avatar.png');
      expect(response.data.user.token, '1|sanctum-token');
    });

    test('rejects success false even when HTTP status is successful', () {
      expect(
        () => GoogleLoginResponseModel.fromJson({
          'success': false,
          'message': 'Invalid Google token.',
        }),
        throwsA(isA<GoogleLoginRejectedException>()),
      );
    });

    test('rejects a response without a Sanctum token', () {
      expect(
        () => GoogleLoginResponseModel.fromJson({
          'success': true,
          'data': {
            'user': {'id': 1, 'name': 'Test User'},
          },
        }),
        throwsA(isA<GoogleLoginResponseException>()),
      );
    });
  });
}

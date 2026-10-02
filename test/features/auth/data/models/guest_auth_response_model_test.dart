import 'package:flutter_test/flutter_test.dart';
import 'package:qaren/features/auth/data/models/guest_auth_response_model.dart';

void main() {
  group('GuestAuthResponseModel', () {
    test('parses a valid nested guest response', () {
      final response = GuestAuthResponseModel.fromJson({
        'success': true,
        'message': 'Guest session created.',
        'data': {'token': 'guest-token', 'is_guest': true},
      });

      expect(response.success, isTrue);
      expect(response.data.token, 'guest-token');
      expect(response.data.isGuest, isTrue);
    });

    test('accepts a top-level guest flag for backward compatibility', () {
      final response = GuestAuthResponseModel.fromJson({
        'success': true,
        'is_guest': 1,
        'data': {'access_token': 'guest-token'},
      });

      expect(response.data.token, 'guest-token');
      expect(response.data.isGuest, isTrue);
    });

    test('rejects a response without a token', () {
      expect(
        () => GuestAuthResponseModel.fromJson({
          'success': true,
          'data': {'is_guest': true},
        }),
        throwsA(isA<GuestAuthResponseException>()),
      );
    });

    test('rejects a response that is not marked as guest', () {
      expect(
        () => GuestAuthResponseModel.fromJson({
          'success': true,
          'data': {'token': 'token', 'is_guest': false},
        }),
        throwsA(isA<GuestAuthResponseException>()),
      );
    });
  });
}

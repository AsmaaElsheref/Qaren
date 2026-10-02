import 'package:flutter_test/flutter_test.dart';
import 'package:qaren/core/utils/validators.dart';

void main() {
  group('optional registration validation', () {
    test('accepts an omitted phone number', () {
      expect(Validators.validateOptionalPhone(null), isNull);
      expect(Validators.validateOptionalPhone('   '), isNull);
    });

    test('validates a supplied phone number', () {
      expect(Validators.validateOptionalPhone('0500000000'), isNull);
      expect(Validators.validateOptionalPhone('+201001234567'), isNull);
    });
  });

  group('login validation', () {
    test('accepts either an email address or a phone number', () {
      expect(Validators.validateLogin('asmaa@gmail.com'), isNull);
      expect(Validators.validateLogin('0500000000'), isNull);
    });
  });
}

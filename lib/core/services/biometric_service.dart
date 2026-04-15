import 'package:local_auth/local_auth.dart';

enum BiometricResult {
  success,
  failed,
  cancelled,
  notAvailable,
  notEnrolled,
  error,
}

class BiometricService {
  final LocalAuthentication _auth;

  BiometricService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  /// Check if device has biometric hardware.
  Future<bool> isDeviceSupported() => _auth.isDeviceSupported();

  /// Check if at least one biometric is enrolled.
  Future<bool> hasEnrolledBiometrics() async {
    final biometrics = await _auth.getAvailableBiometrics();
    return biometrics.isNotEmpty;
  }

  /// Full availability check: hardware + enrolled.
  Future<bool> isAvailable() async {
    final supported = await _auth.isDeviceSupported();
    if (!supported) return false;
    final canCheck = await _auth.canCheckBiometrics;
    if (!canCheck) return false;
    final biometrics = await _auth.getAvailableBiometrics();
    return biometrics.isNotEmpty;
  }

  /// Prompt biometric authentication. Returns a typed result.
  Future<BiometricResult> authenticate({
    String reason = 'قم بالتحقق من هويتك للدخول',
  }) async {
    try {
      final supported = await isDeviceSupported();
      if (!supported) return BiometricResult.notAvailable;

      final enrolled = await hasEnrolledBiometrics();
      if (!enrolled) return BiometricResult.notEnrolled;

      final success = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      return success ? BiometricResult.success : BiometricResult.failed;
    } catch (e) {
      // PlatformException with code "NotAvailable", "NotEnrolled", etc.
      final msg = e.toString().toLowerCase();
      if (msg.contains('cancel') || msg.contains('user cancel')) {
        return BiometricResult.cancelled;
      }
      if (msg.contains('notenrolled')) {
        return BiometricResult.notEnrolled;
      }
      if (msg.contains('notavailable')) {
        return BiometricResult.notAvailable;
      }
      return BiometricResult.error;
    }
  }
}

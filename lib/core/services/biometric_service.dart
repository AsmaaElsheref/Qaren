import 'package:local_auth/local_auth.dart';

/// Thin abstraction over [LocalAuthentication] so the rest of the app
/// depends on an interface, not a concrete plugin class.
abstract class BiometricService {
  /// Returns `true` when the device has at least one enrolled biometric.
  Future<bool> isAvailable();

  /// Prompts the user to authenticate via fingerprint / face.
  /// Returns `true` on success.
  Future<bool> authenticate({required String reason});
}

class BiometricServiceImpl implements BiometricService {
  BiometricServiceImpl();

  final LocalAuthentication _auth = LocalAuthentication();

  @override
  Future<bool> isAvailable() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    return canCheck && isSupported;
  }

  @override
  Future<bool> authenticate({required String reason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}

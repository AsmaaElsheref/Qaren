import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/utils/print/custom_print.dart';

class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.emailRequired'.tr();
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'validation.emailInvalid'.tr();
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.passwordRequired'.tr();
    }
    if (value.length < 6) {
      return 'validation.passwordTooShort'.tr();
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.nameRequired'.tr();
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.phoneRequired'.tr();
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'validation.phoneInvalid'.tr();
    }
    return null;
  }

  static String? confirmPasswordValidator(String? password, value) {
    customPrint('PASS : $password');
    if (value == null || value.isEmpty) {
      return 'validation.confirmPasswordRequired'.tr();
    }
    if (value != password) {
      return 'validation.passwordMismatch'.tr();
    }
    return null;
  }
}

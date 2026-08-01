import 'package:easy_localization/easy_localization.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure([String? message]) : super(message ?? 'errors.network'.tr());
}

class AuthFailure extends Failure {
  AuthFailure([String? message]) : super(message ?? 'errors.unauthorized'.tr());
}

class AuthCancelledFailure extends Failure {
  AuthCancelledFailure([String? message])
      : super(message ?? 'errors.cancelled'.tr());
}

class ServerFailure extends Failure {
  ServerFailure([String? message]) : super(message ?? 'errors.server'.tr());
}

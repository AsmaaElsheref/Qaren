abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'تعذر الاتصال. تحقق من الإنترنت.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'فشل تسجيل الدخول. تحقق من بياناتك.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'حدث خطأ في الخادم. حاول لاحقاً.']);
}


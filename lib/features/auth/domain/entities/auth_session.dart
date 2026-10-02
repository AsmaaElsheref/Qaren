enum AuthSessionType { unauthenticated, guest, authenticated }

class AuthSession {
  final AuthSessionType type;
  final String? token;

  const AuthSession._({required this.type, this.token});

  const AuthSession.unauthenticated()
    : this._(type: AuthSessionType.unauthenticated);

  AuthSession.guest(String token)
    : this._(type: AuthSessionType.guest, token: token);

  AuthSession.authenticated(String token)
    : this._(type: AuthSessionType.authenticated, token: token);

  bool get isGuest => type == AuthSessionType.guest;
  bool get isAuthenticated => type == AuthSessionType.authenticated;
  bool get isUnauthenticated => type == AuthSessionType.unauthenticated;
  bool get hasToken => token?.isNotEmpty == true;
}

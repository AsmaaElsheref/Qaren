import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dioHelper/dio_helper.dart';
import '../../../../core/providers/service_providers.dart';
import '../../data/services/auth_session_service.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/guest_auth_data.dart';
import '../../domain/entities/user_entity.dart';

final authSessionServiceProvider = Provider<AuthSessionService>(
  (ref) => AuthSessionService(ref.watch(secureStorageProvider)),
);

final authSessionProvider =
    StateNotifierProvider<AuthSessionNotifier, AuthSession>((ref) {
      final notifier = AuthSessionNotifier(
        ref.watch(authSessionServiceProvider),
      );
      final expireSession = notifier.expire;
      DioHelper.onUnauthorized = expireSession;
      ref.onDispose(() {
        if (identical(DioHelper.onUnauthorized, expireSession)) {
          DioHelper.onUnauthorized = null;
        }
      });
      return notifier;
    });

class AuthSessionNotifier extends StateNotifier<AuthSession> {
  final AuthSessionService _service;

  AuthSessionNotifier(this._service)
    : super(const AuthSession.unauthenticated());

  Future<AuthSession> restore() async {
    try {
      final restored = await _service.restore();
      if (mounted) state = restored;
      return restored;
    } catch (_) {
      await _service.clear();
      const empty = AuthSession.unauthenticated();
      if (mounted) state = empty;
      return empty;
    }
  }

  Future<void> persistAuthenticated(UserEntity user) async {
    final session = await _service.authenticatedSession(user);
    if (mounted) state = session;
  }

  Future<void> persistGuest(GuestAuthData guest) async {
    final session = await _service.guestSession(guest);
    if (mounted) state = session;
  }

  Future<void> clear() async {
    await _service.clear();
    if (mounted) state = const AuthSession.unauthenticated();
  }

  Future<void> expire() => clear();
}

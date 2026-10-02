import 'package:equatable/equatable.dart';

class GuestAuthData extends Equatable {
  final String token;
  final bool isGuest;

  const GuestAuthData({required this.token, required this.isGuest});

  @override
  List<Object> get props => [token, isGuest];
}

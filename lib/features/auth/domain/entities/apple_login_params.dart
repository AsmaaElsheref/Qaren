class AppleLoginParams {
  final String? identityToken;
  final String? appleId;
  final String? email;
  final String? name;
  final String? firstName;
  final String? lastName;

  const AppleLoginParams({
    this.identityToken,
    this.appleId,
    this.email,
    this.name,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() => {
    if (_hasValue(identityToken)) 'identity_token': identityToken!.trim(),
    if (_hasValue(appleId)) 'apple_id': appleId!.trim(),
    if (_hasValue(email)) 'email': email!.trim(),
    if (_hasValue(name)) 'name': name!.trim(),
    if (_hasValue(firstName)) 'first_name': firstName!.trim(),
    if (_hasValue(lastName)) 'last_name': lastName!.trim(),
  };

  static bool _hasValue(String? value) => value?.trim().isNotEmpty ?? false;
}

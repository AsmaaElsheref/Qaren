import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalProfileState {
  final String name;
  final String avatarUrl;
  final String location;
  final String email;
  final String phone;
  final int orders;
  final int trips;
  final double savings;
  final String currency;
  final bool isLogoutLoading;

  const PersonalProfileState({
    required this.name,
    required this.avatarUrl,
    required this.location,
    required this.email,
    required this.phone,
    required this.orders,
    required this.trips,
    required this.savings,
    required this.currency,
    this.isLogoutLoading = false,
  });

  PersonalProfileState copyWith({
    String? name,
    String? avatarUrl,
    String? location,
    String? email,
    String? phone,
    int? orders,
    int? trips,
    double? savings,
    String? currency,
    bool? isLogoutLoading,
  }) {
    return PersonalProfileState(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      location: location ?? this.location,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      orders: orders ?? this.orders,
      trips: trips ?? this.trips,
      savings: savings ?? this.savings,
      currency: currency ?? this.currency,
      isLogoutLoading: isLogoutLoading ?? this.isLogoutLoading,
    );
  }
}

class ProfileIdentity {
  final String name;
  final String location;

  const ProfileIdentity({
    required this.name,
    required this.location,
  });
}

class ProfileStats {
  final int orders;
  final int trips;
  final double savings;
  final String currency;

  const ProfileStats({
    required this.orders,
    required this.trips,
    required this.savings,
    required this.currency,
  });
}

class ProfileContactInfo {
  final String email;
  final String phone;

  const ProfileContactInfo({
    required this.email,
    required this.phone,
  });
}

class PersonalProfileNotifier extends StateNotifier<PersonalProfileState> {
  PersonalProfileNotifier()
      : super(
    const PersonalProfileState(
      name: 'Dinda Kaulina',
      avatarUrl: '',
      location: 'Riyadh, Saudi Arabia',
      email: 'dinda@example.com',
      phone: '+966 55 123 4567',
      orders: 23,
      trips: 48,
      savings: 1250,
      currency: 'ر.س',
    ),
  );

  void updateAvatar(String avatarUrl) {
    state = state.copyWith(avatarUrl: avatarUrl);
  }

  void updateProfile({
    String? name,
    String? location,
    String? email,
    String? phone,
  }) {
    state = state.copyWith(
      name: name,
      location: location,
      email: email,
      phone: phone,
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLogoutLoading: true);

    try {
      // TODO: call existing auth/logout repository or provider here.
      await Future<void>.delayed(const Duration(milliseconds: 500));
    } finally {
      state = state.copyWith(isLogoutLoading: false);
    }
  }
}

final personalProfileProvider =
StateNotifierProvider<PersonalProfileNotifier, PersonalProfileState>(
      (ref) => PersonalProfileNotifier(),
);

final profileAvatarUrlProvider = Provider<String>((ref) {
  return ref.watch(
    personalProfileProvider.select((state) => state.avatarUrl),
  );
});

final profileIdentityProvider = Provider<ProfileIdentity>((ref) {
  return ref.watch(
    personalProfileProvider.select(
          (state) => ProfileIdentity(
        name: state.name,
        location: state.location,
      ),
    ),
  );
});

final profileStatsProvider = Provider<ProfileStats>((ref) {
  return ref.watch(
    personalProfileProvider.select(
          (state) => ProfileStats(
        orders: state.orders,
        trips: state.trips,
        savings: state.savings,
        currency: state.currency,
      ),
    ),
  );
});

final profileContactInfoProvider = Provider<ProfileContactInfo>((ref) {
  return ref.watch(
    personalProfileProvider.select(
          (state) => ProfileContactInfo(
        email: state.email,
        phone: state.phone,
      ),
    ),
  );
});

final profileLogoutLoadingProvider = Provider<bool>((ref) {
  return ref.watch(
    personalProfileProvider.select((state) => state.isLogoutLoading),
  );
});
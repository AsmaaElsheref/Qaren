import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/service_category.dart';

// ── Categories data provider ────────────────────────────────────────────────
final categoriesProvider = Provider<List<ServiceCategory>>((ref) {
  return const [
    ServiceCategory(
      id: 'taxi',
      title: 'تاكسي ومشاوير',
      subtitle: 'مقارنة أوبر وكريم',
      icon: Icons.directions_car_outlined,
      iconColor: Color(0xFFFF9500),
      iconBgColor: Color(0xFFFFF5E6),
    ),
    ServiceCategory(
      id: 'food',
      title: 'توصيل طعام',
      subtitle: 'مقارنة تطبيقات التوصيل',
      icon: Icons.restaurant_menu_rounded,
      iconColor: Color(0xFFE85D5D),
      iconBgColor: Color(0xFFFFF0F0),
    ),
    ServiceCategory(
      id: 'flights',
      title: 'طيران',
      subtitle: 'أفضل العروض',
      icon: Icons.flight_outlined,
      iconColor: Color(0xFF5B9BD5),
      iconBgColor: Color(0xFFEAF4FF),
    ),
    ServiceCategory(
      id: 'hotels',
      title: 'فنادق',
      subtitle: 'إقامة مريحة',
      icon: Icons.apartment_outlined,
      iconColor: Color(0xFF6B7FD7),
      iconBgColor: Color(0xFFEEF0FF),
    ),
    ServiceCategory(
      id: 'insurance',
      title: 'التأمين',
      subtitle: 'تأمين شامل للمركبات',
      icon: Icons.verified_user_outlined,
      iconColor: Color(0xFF1DB899),
      iconBgColor: Color(0xFFE8FAF6),
    ),
    ServiceCategory(
      id: 'car_rental',
      title: 'تأجير سيارات',
      subtitle: 'أحدث الموديلات',
      icon: Icons.car_rental_outlined,
      iconColor: Color(0xFF9B7FD7),
      iconBgColor: Color(0xFFF3EEFF),
    ),
    ServiceCategory(
      id: 'shopping',
      title: 'تسوق',
      subtitle: 'أزياء وإلكترونيات',
      icon: Icons.shopping_bag_outlined,
      iconColor: Color(0xFFE85D9A),
      iconBgColor: Color(0xFFFFF0F7),
    ),
    ServiceCategory(
      id: 'home_services',
      title: 'خدمات منزلية',
      subtitle: 'صيانة، نظافة، سباكة',
      icon: Icons.handyman_outlined,
      iconColor: Color(0xFFD4A017),
      iconBgColor: Color(0xFFFFF8E6),
    ),
    ServiceCategory(
      id: 'moving',
      title: 'شحن العفش',
      subtitle: 'نقل وتركيب آمن',
      icon: Icons.local_shipping_outlined,
      iconColor: Color(0xFF6B7280),
      iconBgColor: Color(0xFFF3F4F6),
    ),
    ServiceCategory(
      id: 'shipping',
      title: 'شحن الطرود',
      subtitle: 'توصيل سريع وآمن',
      icon: Icons.inventory_2_outlined,
      iconColor: Color(0xFF1DB899),
      iconBgColor: Color(0xFFE8FAF6),
    ),
    ServiceCategory(
      id: 'salon',
      title: 'صالونات وسبا',
      subtitle: 'حلاقة,مساج,تجميل',
      icon: Icons.cut,
      iconColor: Color(0xFFE85D5D),
      iconBgColor: Color(0xFFFFF0F0),
    ),
    ServiceCategory(
      id: 'tickets',
      title: 'فعاليات وتذاكر',
      subtitle: 'سينما,حفلات,رياضة',
      icon: Icons.confirmation_num_outlined,
      iconColor: Color(0xFF5B9BD5),
      iconBgColor: Color(0xFFEAF4FF),
    ),
  ];
});

// ── Search query provider ────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');

// ── Filtered categories provider ────────────────────────────────────────────
final filteredCategoriesProvider = Provider<List<ServiceCategory>>((ref) {
  final all = ref.watch(categoriesProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return all;
  return all
      .where((c) =>
          c.title.toLowerCase().contains(query) ||
          c.subtitle.toLowerCase().contains(query))
      .toList();
});

// ── Bottom nav index provider ────────────────────────────────────────────────
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);


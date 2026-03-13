import 'package:flutter/material.dart';

/// Immutable data model for a single taxi app entry.
class TaxiApp {
  final String id;
  final String name;
  final String description;
  final Color iconBgColor;
  final Color iconColor;
  final IconData icon;

  const TaxiApp({
    required this.id,
    required this.name,
    required this.description,
    required this.iconBgColor,
    required this.iconColor,
    required this.icon,
  });
}

/// The two supported apps — single source of truth.
const kTaxiApps = [
  TaxiApp(
    id: 'uber',
    name: 'أوبر',
    description: 'سريع وموثوق',
    iconBgColor: Color(0xFF1A1A1A),
    iconColor: Color(0xFFFFFFFF),
    icon: Icons.directions_car_rounded,
  ),
  TaxiApp(
    id: 'careem',
    name: 'كريم',
    description: 'الخيار المحلي المفضل',
    iconBgColor: Color(0xFF4CAF50),
    iconColor: Color(0xFFFFFFFF),
    icon: Icons.directions_car_filled_rounded,
  ),
];


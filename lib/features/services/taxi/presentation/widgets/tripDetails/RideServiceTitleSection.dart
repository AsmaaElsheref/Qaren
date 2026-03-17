import 'package:flutter/material.dart';

class RideServiceTitleSection extends StatelessWidget {
  const RideServiceTitleSection({super.key, required this.serviceName});

  final String serviceName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          serviceName,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F5F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'خدمة توصيل',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F9D8B),
            ),
          ),
        ),
      ],
    );
  }
}
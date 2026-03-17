import 'package:flutter/material.dart';

class RouteCenterDivider extends StatelessWidget {
  const RouteCenterDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(
            8, (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 8,
              height: 2,
              color: const Color(0xFFD1D5DB),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFD1D5DB)),
          ),
          child: const Center(
            child: Icon(
              Icons.local_taxi_outlined,
              size: 18,
              color: Color(0xFF4B5563),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '١٥ دقيقة',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
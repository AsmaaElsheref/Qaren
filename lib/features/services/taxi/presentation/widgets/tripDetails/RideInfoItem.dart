import 'package:flutter/material.dart';

class RideInfoItem extends StatelessWidget {
  const RideInfoItem({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}
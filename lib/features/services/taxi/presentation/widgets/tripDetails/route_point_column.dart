import 'package:flutter/material.dart';

class RoutePointColumn extends StatelessWidget {
  const RoutePointColumn({super.key,
    required this.alignment,
    required this.label,
    required this.mainText,
    required this.subText,
  });

  final CrossAxisAlignment alignment;
  final String label;
  final String mainText;
  final String subText;

  @override
  Widget build(BuildContext context) {
    final textAlign = alignment == CrossAxisAlignment.end ? TextAlign.left : TextAlign.right;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          mainText,
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subText,
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}
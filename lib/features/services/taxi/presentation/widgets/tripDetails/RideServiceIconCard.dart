import 'package:flutter/material.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';

class RideServiceIconCard extends StatelessWidget {
  const RideServiceIconCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth*0.22,
      height: context.screenHeight*0.09,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '🚗',
          style: TextStyle(fontSize: 34),
        ),
      ),
    );
  }
}
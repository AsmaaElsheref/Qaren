import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/profile/presentation/providers/profileSettings/profile_settings_provider.dart';
import '../../constants/app_images.dart';

class LogoLoading extends ConsumerStatefulWidget {
  const LogoLoading({super.key});

  @override
  ConsumerState<LogoLoading> createState() => _LogoLoadingState();
}

class _LogoLoadingState extends ConsumerState<LogoLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(profileIsDarkModeProvider);
    return Center(
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // الـ Loading الكبير المتحرك
            RotationTransition(
              turns: _controller,
              child: CustomPaint(
                size: const Size(280, 280),
                painter: LoadingCirclePainter(),
              ),
            ),

            // اللوجو ثابت في المنتصف
            Image.asset(
              isDarkMode ? AppImages.qarenDarkLogo : AppImages.Logo,
              width: 120,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width / 2 - 15;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    // الدائرة الخفيفة في الخلفية
    final backgroundPaint = Paint()
      ..color = Colors.blue.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    // الجزء المتحرك من الدائرة
    final loadingPaint = Paint()
      ..shader = const SweepGradient(
        colors: [
          Colors.transparent,
          Color(0xff55B947),
          Color(0xff009FE3),
          Color(0xff009FE3),
        ],
        stops: [
          0.0,
          0.35,
          0.75,
          1.0,
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 1.65,
      false,
      loadingPaint,
    );

    // النقطة الموجودة في نهاية الـ Loading
    final endAngle = -math.pi / 2 + math.pi * 1.65;

    final dotPosition = Offset(
      center.dx + radius * math.cos(endAngle),
      center.dy + radius * math.sin(endAngle),
    );

    final dotPaint = Paint()
      ..color = const Color(0xff009FE3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      dotPosition,
      7,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
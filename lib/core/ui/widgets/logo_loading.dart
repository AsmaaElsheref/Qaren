import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../constants/app_images.dart';

class LogoLoading extends StatefulWidget {
  const LogoLoading({super.key});

  @override
  State<LogoLoading> createState() => _LogoLoadingState();
}

class _LogoLoadingState extends State<LogoLoading>
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

            // Use the transparent source asset in both themes and crop the
            // wordmark so only the Qaren mark appears inside the spinner.
            const _TransparentQarenMark(),
          ],
        ),
      ),
    );
  }
}

class _TransparentQarenMark extends StatelessWidget {
  const _TransparentQarenMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 134,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.topCenter,
          minWidth: 250,
          maxWidth: 250,
          minHeight: 234,
          maxHeight: 234,
          child: Image.asset(
            AppImages.qarenLogo,
            width: 250,
            height: 234,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class LoadingCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2 - 15;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // الدائرة الخفيفة في الخلفية
    final backgroundPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // الجزء المتحرك من الدائرة
    final loadingPaint = Paint()
      ..shader = const SweepGradient(
        colors: [
          Colors.transparent,
          Color(0xff55B947),
          Color(0xff009FE3),
          Color(0xff009FE3),
        ],
        stops: [0.0, 0.35, 0.75, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -math.pi / 2, math.pi * 1.65, false, loadingPaint);

    // النقطة الموجودة في نهاية الـ Loading
    final endAngle = -math.pi / 2 + math.pi * 1.65;

    final dotPosition = Offset(
      center.dx + radius * math.cos(endAngle),
      center.dy + radius * math.sin(endAngle),
    );

    final dotPaint = Paint()
      ..color = const Color(0xff009FE3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(dotPosition, 7, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

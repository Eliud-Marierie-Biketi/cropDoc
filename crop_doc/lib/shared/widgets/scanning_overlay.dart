import 'package:flutter/material.dart';

class ScanningOverlay extends StatefulWidget {
  const ScanningOverlay({super.key});

  @override
  State<ScanningOverlay> createState() => _ScanningOverlayState();
}

class _ScanningOverlayState extends State<ScanningOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          painter: _ScanningOverlayPainter(progress: _controller.value),
          size: const Size(double.infinity, 200),
        );
      },
    );
  }
}

class _ScanningOverlayPainter extends CustomPainter {
  final double progress;

  _ScanningOverlayPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final y = progress * size.height;

    // Fading green background under line
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.green.withOpacity(0.15),
          Colors.transparent,
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, y - 20, size.width, 40));

    canvas.drawRect(Rect.fromLTWH(0, y - 20, size.width, 40), gradientPaint);

    // Bright green line
    final linePaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2;

    canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
  }

  @override
  bool shouldRepaint(covariant _ScanningOverlayPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

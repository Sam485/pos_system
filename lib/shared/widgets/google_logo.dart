import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;
  const GoogleLogo({super.key, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size, height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c  = Offset(size.width / 2, size.height / 2);
    final r  = size.width / 2;
    final sw = size.width * 0.18;

    void arc(Color color, double start, double sweep) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r - sw / 2),
        start, sweep, false,
        Paint()
          ..color       = color
          ..style       = PaintingStyle.stroke
          ..strokeWidth = sw
          ..strokeCap   = StrokeCap.butt,
      );
    }

    arc(const Color(0xFF4285F4), -0.52, 1.57); // blue
    arc(const Color(0xFF34A853),  1.05, 1.57); // green
    arc(const Color(0xFFFBBC05),  2.62, 0.79); // yellow
    arc(const Color(0xFFEA4335), -1.31, 0.79); // red
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
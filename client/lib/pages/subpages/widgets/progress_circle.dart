import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:soul_connection/constants/constants.dart';

class CircleProgressIndicator extends StatefulWidget {
  const CircleProgressIndicator({
    super.key,
    this.hoveredIndex,
    required this.compatibility,
  });
  final int? hoveredIndex;
  final int compatibility;

  @override
  CircleProgressIndicatorState createState() => CircleProgressIndicatorState();
}

class CircleProgressIndicatorState extends State<CircleProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = kIsWeb
        ? (widget.hoveredIndex != 2 ? dw(context) / 6 : dw(context) / 5)
        : 150;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: size,
              width: size,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(200)),
              child: const CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffeaeef6)),
                backgroundColor: Colors.transparent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: size,
                width: size,
                child: CustomPaint(
                  painter: HeartPainter(
                    2,
                    const Color(0xffeaeef6),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: size,
                width: size,
                child: CustomPaint(
                  painter: HeartPainter(
                      (_animation.value * widget.compatibility) / 100,
                      Colors.pinkAccent),
                ),
              ),
            ),
            Text(
              '${(_animation.value * widget.compatibility).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }
}

class HeartPainter extends CustomPainter {
  final double progress;
  final Color color;

  HeartPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Path path = Path();
    double width = size.width;
    double height = size.height;
    path.moveTo(width / 2, height / 3);
    path.cubicTo(width * 5 / 6, 0, width, height / 2.5, width / 2, height);
    path.cubicTo(0, height / 2.5, width / 6, 0, width / 2, height / 3);

    PathMetric pathMetric = path.computeMetrics().first;
    Path animatedPath = pathMetric.extractPath(0, pathMetric.length * progress);

    canvas.drawPath(animatedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

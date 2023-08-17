import 'dart:math' as math;

import 'package:flutter/material.dart';

class Wave extends StatefulWidget {
  final double? value;
  final Color color;
  final Axis direction;
  final double waveCount;
  final double amplitude;

  const Wave({
    Key? key,
    required this.value,
    required this.color,
    required this.direction,
    required this.waveCount,
    required this.amplitude,
  }) : super(key: key);

  @override
  _WaveState createState() => _WaveState();
}

class _WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
      builder: (context, child) => ClipPath(
        child: Container(
          color: widget.color,
        ),
        clipper: _WaveClipper(
            animationValue: _animationController.value,
            value: widget.value,
            direction: widget.direction,
            waveCount: widget.waveCount,
            amplitude: widget.amplitude),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  final double animationValue;
  final double? value;
  final Axis direction;
  final double waveCount;
  final double amplitude;

  _WaveClipper({
    required this.animationValue,
    required this.value,
    required this.direction,
    required this.waveCount,
    required this.amplitude,
  });

  @override
  Path getClip(Size size) {
    double p = value ?? 50 / 100.0;
    Path path = Path();

    if (direction == Axis.horizontal) {
      double baseWidth = p * size.width;

      path.moveTo(baseWidth, 0.0);
      for (double i = 0.0; i < size.height; i++) {
        path.lineTo(
            baseWidth + math.sin((i / size.height * 2 * math.pi * waveCount) + (animationValue * 2 * math.pi) + math.pi * 1) * amplitude,
            i
        );
      }

      path.lineTo(0.0, size.height);
      path.lineTo(0.0, 0.0);
    } else {
      double baseHeight = (1 - p) * size.height;

      path.moveTo(0.0, baseHeight);
      for (double i = 0.0; i < size.width; i++) {
        path.lineTo(
            i,
            baseHeight + math.sin((i / size.width * 2 * math.pi * waveCount) + (animationValue * 2 * math.pi) + math.pi * 1) * amplitude
        );
      }

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) =>
      animationValue != oldClipper.animationValue;
}

import 'dart:math' as math;

import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';

/// A widget that applies an animated shiny/shimmer sweep effect to its child.
class ShimmerText extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const ShimmerText({
    super.key,
    required this.child,
    required this.baseColor,
    this.highlightColor = Colors.white,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
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
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            // Slide the gradient across the text bounds based on animation value.
            final slide = _controller.value;
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
              begin: Alignment(-1.0 + slide * 3, 0),
              end: Alignment(0.0 + slide * 3, 0),
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class AnimatedBorderButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double borderRadius;
  final double borderWidth;
  final double height;
  final Color backgroundColor;
  final List<Color> gradientColors;
  final Duration duration;

  const AnimatedBorderButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.borderRadius = 26,
    this.borderWidth = 1,
    this.height = 52,
    this.backgroundColor = Colors.black,
    this.gradientColors = const [
      Colors.transparent,
      AppColors.primary,
      Colors.transparent,
    ],
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedBorderButton> createState() => _AnimatedBorderButtonState();
}

class _AnimatedBorderButtonState extends State<AnimatedBorderButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _TravelingBorderPainter(
              progress: _controller.value,
              borderRadius: widget.borderRadius,
              strokeWidth: widget.borderWidth,
              colors: widget.gradientColors,
            ),
            child: Padding(padding: const EdgeInsets.all(5), child: child),
          );
        },
        child: Material(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onTap: widget.onPressed,
            child: Padding(
              padding: EdgeInsets.all(widget.borderWidth + 2),
              child: Center(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}

class _TravelingBorderPainter extends CustomPainter {
  final double progress; // 0..1, one full lap
  final double borderRadius;
  final double strokeWidth;
  final List<Color> colors;

  _TravelingBorderPainter({
    required this.progress,
    required this.borderRadius,
    required this.strokeWidth,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final gradient = SweepGradient(
      colors: colors,
      transform: GradientRotation(progress * 2 * math.pi),
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _TravelingBorderPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

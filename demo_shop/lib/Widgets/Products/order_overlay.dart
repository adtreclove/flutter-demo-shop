import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo_shop/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showOrderSuccessOverlay(
  BuildContext context, {
  String message = 'Order placed!',
}) {
  final completer = Completer<void>();
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _OrderSuccessOverlay(
      message: message,
      onFinished: () {
        entry.remove();
        if (!completer.isCompleted) completer.complete();
      },
    ),
  );

  Overlay.of(context).insert(entry);
  return completer.future;
}

class _OrderSuccessOverlay extends StatefulWidget {
  final String message;
  final VoidCallback onFinished;

  const _OrderSuccessOverlay({required this.message, required this.onFinished});

  @override
  State<_OrderSuccessOverlay> createState() => _OrderSuccessOverlayState();
}

class _OrderSuccessOverlayState extends State<_OrderSuccessOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _backdropOpacity;
  late final Animation<double> _circleScale;
  late final Animation<double> _checkmarkProgress;
  late final Animation<double> _textOpacity;
  late final Animation<double> _exitOpacity;

  static const _totalDuration = Duration(milliseconds: 2200);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _totalDuration);

    _backdropOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.15, curve: Curves.easeOut),
    );

    _circleScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.08, 0.4, curve: Curves.elasticOut),
    );

    _checkmarkProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.6, curve: Curves.easeOut),
    );

    _textOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.75, curve: Curves.easeOut),
    );

    _exitOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.85, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onFinished();
    });
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
        final exitFade = 1 - _exitOpacity.value;

        return Opacity(
          opacity: exitFade,
          child: Stack(
            children: [
              // Dimmed backdrop
              Opacity(
                opacity: _backdropOpacity.value * 0.55,
                child: Container(color: Colors.black),
              ),

              // Centered card
              Center(
                child: Transform.scale(
                  scale: _circleScale.value,
                  child: Container(
                    width: 160,
                    height: 160,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomPaint(
                            painter: _CheckmarkPainter(
                              progress: _checkmarkProgress.value,
                              color: AppColors.primary,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withValues(
                                  alpha: 0.12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Opacity(
                          opacity: _textOpacity.value,
                          child: Text(
                            widget.message,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Draws a circle outline plus a checkmark inside it, both "drawn on"
/// progressively as [progress] goes 0 -> 1 (circle finishes first, then
/// the checkmark strokes in).
class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckmarkPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 4;

    // First half of progress draws the circle, second half draws the
    // checkmark — gives a natural "ring completes, then check appears"
    // feel instead of both animating simultaneously.
    final circleProgress = (progress / 0.5).clamp(0.0, 1.0);
    final checkProgress = ((progress - 0.5) / 0.5).clamp(0.0, 1.0);

    if (circleProgress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2,
        2 * 3.14159 * circleProgress,
        false,
        paint,
      );
    }

    if (checkProgress > 0) {
      final checkPath = Path()
        ..moveTo(center.dx - radius * 0.45, center.dy)
        ..lineTo(center.dx - radius * 0.1, center.dy + radius * 0.35)
        ..lineTo(center.dx + radius * 0.5, center.dy - radius * 0.35);

      final metric = checkPath.computeMetrics().first;
      final extracted = metric.extractPath(0, metric.length * checkProgress);
      canvas.drawPath(extracted, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

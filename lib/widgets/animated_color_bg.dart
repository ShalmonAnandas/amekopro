import 'package:flutter/material.dart';
import 'dart:math';

/// An animated background widget that displays moving gradient blobs.
///
/// This widget creates an animated background effect using three overlapping
/// radial gradients ("blobs") that move in smooth, organic patterns. Each blob
/// has its own color that shifts through the HSL color space over time.
///
/// The animation runs continuously in a 30-second loop, with each blob following
/// a unique mathematical path using sine and cosine functions to create natural,
/// flowing movement.
///
/// Example usage:
/// ```dart
/// Stack(
///   children: [
///     AnimatedColorBg(), // Add as background
///     YourContent(),     // Content appears on top
///   ],
/// )
/// ```
///
/// The widget handles its own animation state management and cleanup through the
/// [initState] and [dispose] methods.
class AnimatedColorBg extends StatefulWidget {
  const AnimatedColorBg({super.key});

  @override
  State<AnimatedColorBg> createState() => _AnimatedColorBgState();
}

/// The state class for [AnimatedColorBg].
///
/// This class manages the animation controller and builds the animated gradient
/// effect. It uses [SingleTickerProviderStateMixin] to efficiently handle the
/// animation ticking.
class _AnimatedColorBgState extends State<AnimatedColorBg>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
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
      builder: (context, child) {
        final double blob1X =
            sin(_controller.value * 2 * pi + cos(_controller.value * pi)) * 0.6;
        final double blob1Y =
            cos(_controller.value * 2 * pi + sin(_controller.value * pi)) * 0.6;
        final double blob2X = sin(_controller.value * 1.8 * pi -
                cos(_controller.value * 1.5 * pi)) *
            0.7;
        final double blob2Y = cos(_controller.value * 1.9 * pi +
                sin(_controller.value * 1.2 * pi)) *
            0.7;
        final double blob3X = cos(_controller.value * 1.7 * pi +
                sin(_controller.value * 1.4 * pi)) *
            0.65;
        final double blob3Y = sin(_controller.value * 2.2 * pi -
                cos(_controller.value * 1.6 * pi)) *
            0.65;

        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(blob1X, blob1Y),
                  radius: 1.8,
                  colors: [
                    HSLColor.fromAHSL(
                            1, (_controller.value * 360) % 360, 0.9, 0.6)
                        .toColor()
                        .withOpacity(0.3),
                    HSLColor.fromAHSL(
                            1, (_controller.value * 360) % 360, 0.9, 0.6)
                        .toColor()
                        .withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(blob2X, blob2Y),
                  radius: 1.8,
                  colors: [
                    HSLColor.fromAHSL(
                            1, (_controller.value * 360 + 120) % 360, 0.9, 0.6)
                        .toColor()
                        .withOpacity(0.3),
                    HSLColor.fromAHSL(
                            1, (_controller.value * 360 + 120) % 360, 0.9, 0.6)
                        .toColor()
                        .withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(blob3X, blob3Y),
                  radius: 1.8,
                  colors: [
                    HSLColor.fromAHSL(
                            1, (_controller.value * 360 + 240) % 360, 0.9, 0.6)
                        .toColor()
                        .withOpacity(0.3),
                    HSLColor.fromAHSL(
                            1, (_controller.value * 360 + 240) % 360, 0.9, 0.6)
                        .toColor()
                        .withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

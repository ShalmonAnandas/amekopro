import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A customizable button widget with a frosted glass effect.
///
/// This button features a semi-transparent background with blur effect, creating
/// a "glassy" appearance. It supports text, optional icons, and includes tap
/// animations.
///
/// The button can be customized with:
/// - Text content
/// - Optional icon (either a default rotating arrow or custom icon)
/// - Border radius
/// - Width
/// - Padding
///
/// Example usage:
/// ```dart
/// GlassyButton(
///   onTap: () => print('Button tapped'),
///   text: Text('Click Me'),
///   borderRadius: 8,
///   showIcon: true,
/// )
/// ```
class GlassyButton extends StatefulWidget {
  /// Creates a glassy button.
  const GlassyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.showIcon = false,
    this.icon,
    required this.borderRadius,
    this.width,
    this.textVerticalPadding,
    this.textHorizontalPadding,
  });

  /// Callback function when button is tapped
  final VoidCallback onTap;

  /// The text content to display in the button
  final Widget text;

  /// Whether to show the default rotating arrow icon
  final bool showIcon;

  /// Optional custom icon widget to display instead of the default arrow
  final Widget? icon;

  /// The border radius of the button in logical pixels
  final int borderRadius;

  /// Optional fixed width for the button. If null, button sizes to content
  final double? width;

  /// Optional vertical padding around the text in logical pixels
  final int? textVerticalPadding;

  /// Optional horizontal padding around the text in logical pixels
  final int? textHorizontalPadding;

  @override
  State<GlassyButton> createState() => _GlassyButtonState();
}

class _GlassyButtonState extends State<GlassyButton> {
  double turns = 0.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          borderRadius: BorderRadius.circular(widget.borderRadius.toDouble()),
          onTap: () {
            setState(() {
              turns += 0.5;
            });
            widget.onTap();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius.toDouble()),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 8,
                sigmaY: 8,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius.toDouble()),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: widget.textVerticalPadding?.toDouble() ?? 16,
                    horizontal: widget.textHorizontalPadding?.toDouble() ?? 24,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.text,
                      if (widget.showIcon)
                        const SizedBox(
                          width: 8,
                        ),
                      if (widget.showIcon)
                        AnimatedRotation(
                          turns: turns,
                          duration: const Duration(milliseconds: 200),
                          child: SvgPicture.asset("assets/arrow-up.svg"),
                        ),
                      if (widget.icon != null) widget.icon!,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

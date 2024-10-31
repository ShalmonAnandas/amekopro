import 'package:amekopro/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom text widget that uses the Sora font family with consistent styling.
///
/// This widget wraps Flutter's [Text] widget and applies the Sora font family
/// along with customizable text properties. It provides default values for font size,
/// weight and color while allowing these to be overridden.
///
/// Example usage:
/// ```dart
/// AmekoText(
///   text: 'Hello World',
///   fontSize: 16,
///   fontWeight: FontWeight.bold,
///   color: Colors.blue,
/// )
/// ```
///
/// Default values:
/// - fontSize: 24
/// - fontWeight: FontWeight.w500 (medium)
/// - color: HexColor("D9E0A4") (light beige)
class AmekoText extends StatelessWidget {
  const AmekoText(
      {super.key,
      required this.text,
      this.fontSize,
      this.fontWeight,
      this.color});

  /// The text string to display
  final String text;

  /// Optional font size in logical pixels. Defaults to 24 if not specified.
  final int? fontSize;

  /// Optional font weight. Defaults to FontWeight.w500 if not specified.
  final FontWeight? fontWeight;

  /// Optional text color. Defaults to HexColor("D9E0A4") if not specified.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.sora(
        fontSize: fontSize?.toDouble() ?? 24,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? HexColor("D9E0A4"),
      ),
    );
  }
}

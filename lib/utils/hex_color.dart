import 'package:flutter/material.dart';

/// A utility class for creating Flutter Color objects from hex color strings.
///
/// This class extends Flutter's Color class to provide easy conversion from
/// hexadecimal color strings to Color objects.
///
/// The class provides:
/// 1. A static method [_getColorFromHex] to parse hex strings to color integers
/// 2. A constructor that takes hex strings in "#RRGGBB" or "RRGGBB" format
///
/// Example usage:
/// ```dart
/// final redColor = HexColor("#FF0000"); // Creates red color
/// final greenColor = HexColor("00FF00"); // Creates green color
/// ```
///
/// This is useful when you need to:
/// - Use hex color codes from design specs
/// - Convert hex strings to Flutter Colors
/// - Create colors from hex values stored in data/config
class HexColor extends Color {
  /// Converts a hex color string to its integer representation.
  ///
  /// Takes a [hexColor] string parameter in the format "#RRGGBB" or "RRGGBB" and
  /// converts it to the corresponding integer color value.
  ///
  /// The function:
  /// 1. Removes any "#" prefix and converts to uppercase
  /// 2. Adds "FF" alpha channel prefix if 6 digit hex provided
  /// 3. Parses the hex string to an integer
  /// 4. Returns black (0xff000000) if parsed value is 0
  ///
  /// Example usage:
  /// ```dart
  /// final color = HexColor("#FF0000"); // Creates red color
  /// final color2 = HexColor("00FF00"); // Creates green color
  /// ```
  ///
  /// Returns an integer representing the color value that can be used by Flutter's
  /// Color class.
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }

    final hexNum = int.parse(hexColor, radix: 16);

    if (hexNum == 0) {
      return 0xff000000;
    }

    return hexNum;
  }

  /// Creates a Color from a hex color string.
  ///
  /// Takes a [hexColor] string in "#RRGGBB" or "RRGGBB" format and creates
  /// a Color object using [_getColorFromHex].
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

/// Converts a Flutter Color object to its hex color representation.
///
/// This class extends Flutter's Color class to provide conversion from Color
/// objects to their hexadecimal representation.
///
/// The class provides:
/// 1. A static method [_convertColorTHex] to convert Color to hex integer
/// 2. A constructor that takes a Color and creates a new Color with hex value
///
/// Example usage:
/// ```dart
/// final color = Colors.red;
/// final hexColor = ColorToHex(color); // Converts to hex representation
/// ```
///
/// This is useful when you need to:
/// - Convert Material Design colors to hex format
/// - Store colors as hex values
/// - Interface with systems expecting hex color values
class ColorToHex extends Color {
  /// Converts a Flutter Color to its hex integer representation.
  ///
  /// Takes a [color] parameter and extracts its underlying value as a hex string,
  /// then parses it back to an integer that can be used by the Color class.
  ///
  /// Returns an integer representing the hex color value.
  static int _convertColorTHex(Color color) {
    var hex = '${color.value}';
    return int.parse(
      hex,
    );
  }

  /// Creates a new Color from an existing Color's hex value.
  ///
  /// Takes a [color] parameter and creates a new Color instance using its
  /// hex value obtained via [_convertColorTHex].
  ColorToHex(final Color color) : super(_convertColorTHex(color));
}

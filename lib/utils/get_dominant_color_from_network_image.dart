import 'package:amekopro/utils/custom_log_printer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

/// Calculates the dominant/average color of an image from a network URL.
///
/// Takes a [url] parameter pointing to an image file and returns a [Color]
/// representing the average color of all pixels in the image.
///
/// The function:
/// 1. Downloads the image from the provided URL
/// 2. Decodes the image bytes into a manipulatable format
/// 3. Resizes the image to 100px width for faster processing
/// 4. Calculates the average RGB values across all pixels
/// 5. Returns a Color object with the average RGB values
///
/// Returns [Colors.transparent] if any errors occur during the process.
///
/// Example usage:
/// ```dart
/// final dominantColor = await getDominantColorFromNetworkImage(
///   'https://example.com/image.jpg'
/// );
/// ```
///
/// Throws:
/// - Exception if the image cannot be fetched from the URL
/// - Exception if the image bytes cannot be decoded
Future<Color> getDominantColorFromNetworkImage(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final imageBytes = response.bodyBytes;
      final image = img.decodeImage(imageBytes);

      if (image != null) {
        // Resize image for faster processing
        final resized = img.copyResize(image, width: 100);

        // Calculate average color
        int totalR = 0, totalG = 0, totalB = 0;
        int pixelCount = 0;

        for (var y = 0; y < resized.height; y++) {
          for (var x = 0; x < resized.width; x++) {
            final pixel = resized.getPixel(x, y);
            totalR += pixel.r.toInt();
            totalG += pixel.g.toInt();
            totalB += pixel.b.toInt();
            pixelCount++;
          }
        }

        return Color.fromRGBO(
          totalR ~/ pixelCount,
          totalG ~/ pixelCount,
          totalB ~/ pixelCount,
          1,
        );
      } else {
        throw Exception("Image is null");
      }
    } else {
      throw Exception("Couldnt fetch image");
    }
  } catch (e, s) {
    CustomLogPrinter.instance.printDebugLog("DominantColorError", e, s);
    return Colors.transparent;
  }
}

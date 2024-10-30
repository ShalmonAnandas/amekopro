import 'package:amekopro/utils/custom_log_printer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

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
      throw Exception("Couldnt Fetch Image");
    }
  } catch (e, s) {
    CustomLogPrinter.instance.printDebugLog("DominantColorError", e, s);
    return Colors.transparent;
  }
}

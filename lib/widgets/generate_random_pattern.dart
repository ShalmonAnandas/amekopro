import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that generates a random, symmetric pattern of shapes.
///
/// This widget creates visually interesting patterns by randomly placing shapes
/// (rectangles, circles, and triangles) in a grid layout. The pattern is made
/// symmetric by mirroring shapes across the vertical center line.
///
/// The generated pattern is deterministic based on the provided [seed] string,
/// meaning the same seed will always produce the same pattern.
///
/// Example usage:
/// ```dart
/// RandomPatternGenerator(
///   size: 100,
///   gridSize: 5,
///   seed: 'user123',
/// )
/// ```
///
/// Key features:
/// - Generates symmetric patterns using three shape types
/// - Connects shapes with lines to create a network effect
/// - Maintains consistency using a seed value
/// - Customizable size and grid density
class RandomPatternGenerator extends StatelessWidget {
  /// The width and height of the pattern in logical pixels
  final double size;

  /// The number of grid cells in each row/column
  final int gridSize;

  /// A string used to generate consistent patterns
  final String seed;

  const RandomPatternGenerator({
    super.key,
    this.size = 50,
    this.gridSize = 5,
    required this.seed,
  });

  @override
  Widget build(BuildContext context) {
    // Use seed to generate consistent patterns for the same user
    final random = Random(seed.hashCode);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: PatternPainter(
          random: random,
          gridSize: gridSize,
        ),
      ),
    );
  }
}

/// Stores position and size information for shapes in the pattern.
///
/// Used to track shape locations for drawing connecting lines between shapes.
class ShapeInfo {
  /// The center point of the shape
  final Offset center;

  /// The size (width/height) of the shape
  final double size;
  ShapeInfo(this.center, this.size);
}

/// Custom painter that handles the actual drawing of the pattern.
///
/// This painter creates a symmetric pattern by:
/// 1. Drawing shapes in random positions within a grid
/// 2. Mirroring shapes across the vertical center line
/// 3. Connecting nearby shapes with lines
class PatternPainter extends CustomPainter {
  /// Random number generator initialized with a seed
  final Random random;

  /// Number of cells in the grid (both horizontally and vertically)
  final int gridSize;

  PatternPainter({
    required this.random,
    required this.gridSize,
  });

  // Add a class to store shape information

  @override
  void paint(Canvas canvas, Size size) {
    // Make cells smaller to bring shapes closer together
    final cellSize = size.width / (gridSize * 0.7); // Reduced cell spacing
    final paint = Paint();

    // Store centers of shapes for drawing lines later
    List<ShapeInfo> shapePositions = [];

    // Calculate offset to center the whole pattern
    final totalWidth = cellSize * gridSize;
    final startOffset = (size.width - totalWidth) / 2;

    // Create a symmetric pattern
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (j <= gridSize ~/ 2) {
          if (random.nextDouble() < 0.95) {
            paint.color = Color.fromARGB(
              179,
              random.nextInt(255),
              random.nextInt(255),
              random.nextInt(255),
            );

            final shape = random.nextInt(3);
            final shapeSize = cellSize *
                (0.5 + random.nextDouble() * 0.4); // Slightly larger base size

            // Increased overlap amount
            final overlapAmount = shapeSize * 0.4;
            final offsetX = random.nextDouble() * (cellSize + overlapAmount) -
                overlapAmount;
            final offsetY = random.nextDouble() * (cellSize + overlapAmount) -
                overlapAmount;

            final left = startOffset +
                (j * cellSize * 0.7) +
                offsetX; // Reduced horizontal spacing
            final top =
                (i * cellSize * 0.7) + offsetY; // Reduced vertical spacing
            final mirroredLeft =
                startOffset + ((gridSize - 1 - j) * cellSize * 0.7) + offsetX;

            // Store center positions of shapes
            final center = Offset(left + shapeSize / 2, top + shapeSize / 2);
            shapePositions.add(ShapeInfo(center, shapeSize));

            // Store mirrored shape center if not in the middle
            if (j != gridSize ~/ 2) {
              final mirroredCenter =
                  Offset(mirroredLeft + shapeSize / 2, top + shapeSize / 2);
              shapePositions.add(ShapeInfo(mirroredCenter, shapeSize));
            }

            final rotation = random.nextDouble() * 2 * pi;

            switch (shape) {
              case 0:
                _drawShape(canvas, paint, left, top, shapeSize,
                    ShapeType.rectangle, rotation);
                if (j != gridSize ~/ 2) {
                  _drawShape(canvas, paint, mirroredLeft, top, shapeSize,
                      ShapeType.rectangle, rotation);
                }
              case 1:
                _drawShape(canvas, paint, left, top, shapeSize,
                    ShapeType.circle, rotation);
                if (j != gridSize ~/ 2) {
                  _drawShape(canvas, paint, mirroredLeft, top, shapeSize,
                      ShapeType.circle, rotation);
                }
              case 2:
                _drawShape(canvas, paint, left, top, shapeSize,
                    ShapeType.triangle, rotation);
                if (j != gridSize ~/ 2) {
                  _drawShape(canvas, paint, mirroredLeft, top, shapeSize,
                      ShapeType.triangle, rotation);
                }
            }
          }
        }
      }
    }

    // Draw lines between shapes
    if (shapePositions.length > 1) {
      final linePaint = Paint()
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      // Connect each shape to its 2-3 nearest neighbors
      for (int i = 0; i < shapePositions.length; i++) {
        var distances = <int, double>{};

        // Calculate distances to all other shapes
        for (int j = 0; j < shapePositions.length; j++) {
          if (i != j) {
            double distance =
                (shapePositions[i].center - shapePositions[j].center).distance;
            distances[j] = distance;
          }
        }

        // Sort distances and get 2-3 nearest neighbors
        var sortedDistances = distances.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value));

        int connectCount = 2 + random.nextInt(2); // Connect to 2-3 neighbors
        for (int k = 0; k < min(connectCount, sortedDistances.length); k++) {
          // Set bright line color
          linePaint.color = Color.fromARGB(
            255,
            150 + random.nextInt(106), // Brighter colors (150-255)
            150 + random.nextInt(106),
            150 + random.nextInt(106),
          );

          canvas.drawLine(
            shapePositions[i].center,
            shapePositions[sortedDistances[k].key].center,
            linePaint,
          );
        }
      }
    }
  }

  /// Draws a single shape on the canvas with the specified parameters.
  ///
  /// The shape is drawn with rotation applied around its center point.
  ///
  /// Parameters:
  /// - [canvas] The canvas to draw on
  /// - [paint] The paint style to use
  /// - [left] Left position of the shape
  /// - [top] Top position of the shape
  /// - [size] Size of the shape
  /// - [type] Type of shape to draw (rectangle, circle, or triangle)
  /// - [rotation] Rotation angle in radians
  void _drawShape(Canvas canvas, Paint paint, double left, double top,
      double size, ShapeType type, double rotation) {
    // Save the current canvas state
    canvas.save();

    // Translate to the center of where the shape will be drawn
    canvas.translate(left + size / 2, top + size / 2);
    // Apply rotation
    canvas.rotate(rotation);
    // Translate back
    canvas.translate(-(left + size / 2), -(top + size / 2));

    switch (type) {
      case ShapeType.rectangle:
        canvas.drawRect(
          Rect.fromLTWH(left, top, size, size),
          paint,
        );
      case ShapeType.circle:
        canvas.drawCircle(
          Offset(left + size / 2, top + size / 2),
          size / 2,
          paint,
        );
      case ShapeType.triangle:
        final path = Path();
        path.moveTo(left + size / 2, top); // Top vertex
        path.lineTo(left, top + size); // Bottom left
        path.lineTo(left + size, top + size); // Bottom right
        path.close();
        canvas.drawPath(path, paint);
    }

    // Restore the canvas state
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Defines the available shape types for the pattern.
enum ShapeType {
  /// A rectangular shape
  rectangle,

  /// A circular shape
  circle,

  /// A triangular shape
  triangle,
}

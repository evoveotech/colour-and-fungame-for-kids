import 'dart:ui';
import 'package:flutter/material.dart';

/// Different drawing tools available in the colouring screen.
///
/// - `brush`: default soft brush.
/// - `pencil`: thin pencil line.
/// - `fill`: tap-to-fill style (direct colour).
/// - `rainbow`: colour changes while drawing.
/// - `sticker`: stamps / patterns along the path.
/// - `glitter`: shiny sketch‑pen style.
/// - `eraser`: erases strokes.
enum StrokeType {
  brush,
  pencil,
  fill,
  rainbow,
  sticker,
  glitter,
  eraser,
}

class Stroke {
  final List<Offset> points;
  final Color color;
  final double size;
  final StrokeType type;

  Stroke({
    required this.points,
    required this.color,
    required this.size,
    required this.type,
  });
}

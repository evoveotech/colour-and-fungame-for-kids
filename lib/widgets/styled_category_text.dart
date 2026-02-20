import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Styled category text matching `HomeScreen` design:
/// - Category-color gradient fill
/// - Dark outline stroke
/// - White highlight shine
/// - Soft drop shadow
class StyledCategoryText extends StatelessWidget {
  final String text;
  final Color categoryColor;

  /// Optional fixed size (kept to match original design).
  final double width;
  final double height;

  const StyledCategoryText({
    super.key,
    required this.text,
    required this.categoryColor,
    this.width = 320,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _StyledTextPainter(
          text: text,
          categoryColor: categoryColor,
        ),
      ),
    );
  }
}

class _StyledTextPainter extends CustomPainter {
  final String text;
  final Color categoryColor;

  _StyledTextPainter({
    required this.text,
    required this.categoryColor,
  });

  Color _darken(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  Color _lighten(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final baseTextStyle = GoogleFonts.comfortaa(
      fontSize: 34,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.5,
      height: 1.0,
    );

    // Apply the original slight offset (for better visual centering).
    canvas.save();
    canvas.translate(-10, 5);

    final outlineColor = _darken(categoryColor, 0.3);
    final shadowColor = _lighten(categoryColor, 0.4).withValues(alpha: 0.6);
    final gradientStart = _darken(categoryColor, 0.15);
    final gradientEnd = _lighten(categoryColor, 0.2);
    final highlightColor = Colors.white.withValues(alpha: 0.6);

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: baseTextStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final textX = (size.width - textPainter.width) / 2;
    final textY = (size.height - textPainter.height) / 2;

    _drawStraightText(
      canvas,
      text,
      baseTextStyle,
      textX,
      textY,
      shadowColor,
      outlineColor,
      gradientStart,
      gradientEnd,
      highlightColor,
      shadowOffset: const Offset(1, 4),
    );

    canvas.restore();
  }

  void _drawStraightText(
    Canvas canvas,
    String text,
    TextStyle baseStyle,
    double x,
    double y,
    Color shadowColor,
    Color outlineColor,
    Color gradientStart,
    Color gradientEnd,
    Color highlightColor, {
    Offset shadowOffset = const Offset(1, 4),
  }) {
    // Shadow
    final shadowStyle = baseStyle.copyWith(color: shadowColor);
    final shadowPainter = TextPainter(
      text: TextSpan(text: text, style: shadowStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    shadowPainter.paint(canvas, Offset(x + shadowOffset.dx, y + shadowOffset.dy));

    // Outline
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = outlineColor
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final outlineStyle = baseStyle.copyWith(foreground: outlinePaint);
    final outlinePainter = TextPainter(
      text: TextSpan(text: text, style: outlineStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    outlinePainter.paint(canvas, Offset(x, y));

    // Gradient fill
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [gradientStart, gradientEnd],
    );
    final gradientRect = Rect.fromLTWH(x, y, shadowPainter.width, shadowPainter.height);
    final gradientPaint = Paint()..shader = gradient.createShader(gradientRect);
    final gradientStyle = baseStyle.copyWith(foreground: gradientPaint);
    final gradientPainter = TextPainter(
      text: TextSpan(text: text, style: gradientStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    gradientPainter.paint(canvas, Offset(x, y));

    // Highlight shine
    final highlightStyle = baseStyle.copyWith(color: highlightColor);
    final highlightPainter = TextPainter(
      text: TextSpan(text: text, style: highlightStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    highlightPainter.paint(canvas, Offset(x - 1.5, y - 1.5));
  }

  @override
  bool shouldRepaint(covariant _StyledTextPainter oldDelegate) {
    return oldDelegate.text != text || oldDelegate.categoryColor != categoryColor;
  }
}


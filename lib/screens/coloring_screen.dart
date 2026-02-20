import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/stroke.dart';

class ColoringScreen extends StatefulWidget {
  final String templateAsset;
  final String templateName;
  final String? backgroundImagePath;

  const ColoringScreen({
    super.key,
    required this.templateAsset,
    required this.templateName,
    this.backgroundImagePath,
  });

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  final List<Stroke> _strokes = [];
  final List<Stroke> _redoStack = [];
  Color _currentColor = Colors.red;
  double _brushSize = 18;
  StrokeType _currentTool = StrokeType.brush;
  List<Offset>? _currentPoints;
  ui.Image? _templateImage;
  bool _templateLoaded = false;
  final GlobalKey _canvasKey = GlobalKey();

  // Large palette for popup colour selector (like reference UI).
  static const List<Color> _fullPalette = [
    Color(0xFFFF0000),
    Color(0xFFFF5252),
    Color(0xFFFF1744),
    Color(0xFFFF4081),
    Color(0xFFE91E63),
    Color(0xFFF06292),
    Color(0xFFF8BBD0),
    Color(0xFFFFCDD2),
    Color(0xFFFFA000),
    Color(0xFFFFC107),
    Color(0xFFFFD54F),
    Color(0xFFFFE082),
    Color(0xFFFFF59D),
    Color(0xFFFFF9C4),
    Color(0xFFFFE0B2),
    Color(0xFFFFCC80),
    Color(0xFF8BC34A),
    Color(0xFF4CAF50),
    Color(0xFF66BB6A),
    Color(0xFFA5D6A7),
    Color(0xFFC5E1A5),
    Color(0xFFDCEDC8),
    Color(0xFFB2DFDB),
    Color(0xFF80CBC4),
    Color(0xFF26C6DA),
    Color(0xFF00BCD4),
    Color(0xFF4FC3F7),
    Color(0xFF03A9F4),
    Color(0xFF2196F3),
    Color(0xFF64B5F6),
    Color(0xFF90CAF9),
    Color(0xFFBBDEFB),
    Color(0xFF9FA8DA),
    Color(0xFF3F51B5),
    Color(0xFF5C6BC0),
    Color(0xFF673AB7),
    Color(0xFF9575CD),
    Color(0xFFB39DDB),
    Color(0xFFD1C4E9),
    Color(0xFFCE93D8),
    Color(0xFFBA68C8),
    Color(0xFF9C27B0),
    Color(0xFFBDBDBD),
    Color(0xFF9E9E9E),
    Color(0xFF757575),
    Color(0xFF616161),
    Color(0xFF424242),
    Color(0xFF000000),
    Color(0xFFFFFFFF),
  ];

  static const List<Color> _palette = [
    Colors.red,
    Color(0xFFFF9800), // orange
    Colors.amber,
    Colors.yellow,
    Color(0xFF8BC34A), // light green
    Colors.green,
    Color(0xFF00BCD4), // cyan
    Colors.blue,
    Color(0xFF9C27B0), // purple
    Color(0xFFE91E63), // pink
    Colors.brown,
    Colors.black,
    Colors.grey,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    _loadTemplate();
  }

  Future<void> _loadTemplate() async {
    String path = widget.templateAsset;
    for (var i = 0; i < 2; i++) {
      try {
        final byteData = await rootBundle.load(path);
        final codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List());
        final frame = await codec.getNextFrame();
        if (!mounted) return;
        setState(() {
          _templateImage = frame.image;
          _templateLoaded = true;
        });
        return;
      } catch (_) {
        if (i == 0 && path.endsWith('.jpg')) {
          path = path.replaceFirst('.jpg', '.png');
        } else {
          break;
        }
      }
    }
    if (mounted) setState(() => _templateLoaded = false);
  }

  void _onPanStart(DragStartDetails d, BoxConstraints constraints) {
    final pos = _localToCanvas(d.localPosition, constraints);

    // For fill / direct colour, we treat tap as a single filled circle.
    if (_currentTool == StrokeType.fill) {
      setState(() {
        _redoStack.clear();
        _strokes.add(
          Stroke(
            points: [pos],
            color: _currentColor,
            size: max(_brushSize * 2.2, 32),
            type: StrokeType.fill,
          ),
        );
      });
      return;
    }

    setState(() {
      _redoStack.clear();
      _currentPoints = [pos];
    });
  }

  void _onPanUpdate(DragUpdateDetails d, BoxConstraints constraints) {
    final pos = _localToCanvas(d.localPosition, constraints);
    setState(() {
      _currentPoints?.add(pos);
    });
  }

  void _onPanEnd(DragEndDetails d) {
    if (_currentPoints == null || _currentPoints!.length < 2) {
      _currentPoints = null;
      return;
    }
    setState(() {
      _strokes.add(Stroke(
        points: List.from(_currentPoints!),
        color: _currentTool == StrokeType.eraser ? Colors.transparent : _currentColor,
        size: _currentTool == StrokeType.pencil ? 4 : _brushSize,
        type: _currentTool,
      ));
      _currentPoints = null;
    });
  }

  Offset _localToCanvas(Offset local, BoxConstraints constraints) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    return Offset(local.dx.clamp(0.0, w), local.dy.clamp(0.0, h));
  }

  void _undo() {
    if (_strokes.isEmpty) return;
    setState(() {
      _redoStack.add(_strokes.removeLast());
    });
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() {
      _strokes.add(_redoStack.removeLast());
    });
  }

  Future<void> _saveToGallery() async {
    try {
      final boundary = _canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 2);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final pngBytes = byteData.buffer.asUint8List();
      await Gal.putImageBytes(pngBytes, album: 'Kids Colouring');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved to gallery!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _share() async {
    try {
      final boundary = _canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 2);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/share_colouring.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      await Share.shareXFiles([XFile(file.path)], text: 'My colouring!');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  _buildLeftToolbar(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: (_templateImage != null && _templateImage!.height != 0)
                            ? _templateImage!.width / _templateImage!.height
                            : 16 / 9,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return GestureDetector(
                              onPanStart: (d) => _onPanStart(d, constraints),
                              onPanUpdate: (d) => _onPanUpdate(d, constraints),
                              onPanEnd: _onPanEnd,
                              child: RepaintBoundary(
                                key: _canvasKey,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.12),
                                      width: 4,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CustomPaint(
                                      painter: _ColoringPainter(
                                        templateImage: _templateImage,
                                        templateLoaded: _templateLoaded,
                                        strokes: _strokes,
                                        currentPoints: _currentPoints,
                                        currentColor: _currentTool == StrokeType.eraser ? Colors.white : _currentColor,
                                        currentSize: _currentTool == StrokeType.pencil ? 4 : _brushSize,
                                        currentTool: _currentTool,
                                      ),
                                      size: Size(constraints.maxWidth, constraints.maxHeight),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildRightToolbar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    if (widget.backgroundImagePath != null && widget.backgroundImagePath!.isNotEmpty) {
      return Opacity(
        // Made background slightly transparent so focus stays on canvas
        opacity: 0.6,
        child: Image.asset(
          widget.backgroundImagePath!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackGradient(),
        ),
      );
    }
    return _fallbackGradient();
  }

  Widget _fallbackGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB3E5FC),
            Color(0xFFC8E6C9),
            Color(0xFFFFF9C4),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftToolbar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Top: only back button (outside panel).
        _roundSideButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.of(context).pop(),
        ),
        // Bottom: save, undo, clear – all inside one rounded panel.
        Container(
          width: 88,
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.black.withOpacity(0.08),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _roundSideButton(
                  icon: Icons.save_alt,
                  onTap: _saveToGallery,
                ),
                const SizedBox(height: 10),
                _roundSideButton(
                  icon: Icons.undo,
                  onTap: _strokes.isEmpty ? null : _undo,
                ),
                const SizedBox(height: 10),
                _roundSideButton(
                  icon: Icons.delete_forever,
                  onTap: () {
                    setState(() {
                      _strokes.clear();
                      _redoStack.clear();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightToolbar() {
    // Right side controls in a proper rounded panel (as before),
    // but removed the extra pencil (third control) in the middle.
    return Container(
      width: 88,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.black.withOpacity(0.08),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // All colours selector (popup palette)
            GestureDetector(
              onTap: _showColourPicker,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _currentTool == StrokeType.eraser ? Colors.white : _currentColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            _toolIconButton(
              type: StrokeType.pencil,
              icon: Icons.edit,
              tooltip: 'Pencil',
            ),
            const SizedBox(height: 10),
            _toolIconButton(
              type: StrokeType.brush,
              icon: Icons.brush,
              tooltip: 'Brush',
            ),
            // Third (duplicate) pencil removed as requested.
            const SizedBox(height: 10),
            _toolIconButton(
              type: StrokeType.fill,
              icon: Icons.format_color_fill,
              tooltip: 'Direct colour',
            ),
            const SizedBox(height: 10),
            _toolIconButton(
              type: StrokeType.rainbow,
              icon: Icons.gradient,
              tooltip: 'All colours in one',
            ),
            const SizedBox(height: 10),
            _toolIconButton(
              type: StrokeType.sticker,
              icon: Icons.auto_awesome_mosaic,
              tooltip: 'Stickers',
            ),
            const SizedBox(height: 10),
            _toolIconButton(
              type: StrokeType.glitter,
              icon: Icons.auto_awesome,
              tooltip: 'Shiny sketch pen',
            ),
            const SizedBox(height: 10),
            _toolIconButton(
              type: StrokeType.eraser,
              icon: Icons.auto_fix_off,
              tooltip: 'Eraser',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showColourPicker() async {
    final selected = await showDialog<Color>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.all(12),
          content: SizedBox(
            width: 320,
            child: GridView.count(
              crossAxisCount: 8,
              shrinkWrap: true,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              children: _fullPalette
                  .map(
                    (c) => GestureDetector(
                      onTap: () => Navigator.of(context).pop(c),
                      child: Container(
                        decoration: BoxDecoration(
                          color: c,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _currentColor = selected;
        if (_currentTool == StrokeType.eraser) {
          _currentTool = StrokeType.brush;
        }
      });
    }
  }

  Widget _toolIconButton({
    required StrokeType type,
    required IconData icon,
    required String tooltip,
    VoidCallback? onTapOverride,
  }) {
    final selected = _currentTool == type;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: selected ? const Color(0xFFE0852A) : const Color(0xFFFAFAFA),
        shape: const CircleBorder(),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.25),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTapOverride ??
              () {
                setState(() {
                  _currentTool = type;
                });
              },
          child: SizedBox(
            width: 52,
            height: 52,
            child: Icon(
              icon,
              color: selected ? Colors.white : Colors.black87,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _roundSideButton({required IconData icon, VoidCallback? onTap}) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE0852A),
              border: Border.all(
                color: const Color(0xFFF5E0C0),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

class _ColoringPainter extends CustomPainter {
  final ui.Image? templateImage;
  final bool templateLoaded;
  final List<Stroke> strokes;
  final List<Offset>? currentPoints;
  final Color currentColor;
  final double currentSize;
  final StrokeType currentTool;

  _ColoringPainter({
    required this.templateImage,
    required this.templateLoaded,
    required this.strokes,
    required this.currentPoints,
    required this.currentColor,
    required this.currentSize,
    required this.currentTool,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw template image inside a fitted rect.
    Rect? paintArea;

    if (templateLoaded && templateImage != null) {
      final src = Rect.fromLTWH(0, 0, templateImage!.width.toDouble(), templateImage!.height.toDouble());
      final dst = _fitRect(src.size, size);
      paintArea = dst;
      canvas.drawImageRect(templateImage!, src, dst, Paint());
    } else {
      _drawPlaceholderTemplate(canvas, size);
      paintArea = Rect.fromLTWH(0, 0, size.width, size.height);
    }

    if (paintArea != null) {
      // Only allow colouring inside the template area (no colour on outer background).
      canvas.save();
      canvas.clipRect(paintArea);

      // Draw all strokes in a separate layer so eraser (BlendMode.clear)
      // works like real erasing and doesn't affect the template image.
      canvas.saveLayer(paintArea, Paint());

      for (final s in strokes) {
        _drawStroke(canvas, s.points, s.color, s.size, s.type);
      }
      if (currentPoints != null && currentPoints!.length >= 2) {
        _drawStroke(canvas, currentPoints!, currentColor, currentSize, currentTool);
      }

      canvas.restore(); // layer
      canvas.restore(); // clip
    }
  }

  Rect _fitRect(Size src, Size dst) {
    final scale = (dst.width / src.width).clamp(0.0, double.infinity);
    final scaleH = (dst.height / src.height).clamp(0.0, double.infinity);
    final s = scale < scaleH ? scale : scaleH;
    final w = src.width * s;
    final h = src.height * s;
    final x = (dst.width - w) / 2;
    final y = (dst.height - h) / 2;
    return Rect.fromLTWH(x, y, w, h);
  }

  void _drawPlaceholderTemplate(Canvas canvas, Size size) {
    const margin = 40.0;
    final r = Rect.fromLTWH(margin, margin, size.width - 2 * margin, size.height - 2 * margin);
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawOval(r, paint);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.32), 10, paint);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.32), 10, paint);
  }

  void _drawStroke(Canvas canvas, List<Offset> points, Color color, double size, StrokeType type) {
    if (points.isEmpty) return;

    // Direct colour: simple filled circle at tapped position.
    if (type == StrokeType.fill) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(points.first, size, paint);
      return;
    }

    if (points.length < 2) return;

    if (type == StrokeType.rainbow) {
      // Draw each segment with cycling colours (all colours in one).
      final rainbow = [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple,
      ];
      for (var i = 0; i < points.length - 1; i++) {
        final paint = Paint()
          ..color = rainbow[i % rainbow.length]
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = size;
        canvas.drawLine(points[i], points[i + 1], paint);
      }
      return;
    }

    if (type == StrokeType.sticker) {
      // Stamp small rounded rectangles along the path.
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      for (final p in points) {
        final r = Rect.fromCenter(center: p, width: size * 1.2, height: size * 0.8);
        final rp = RRect.fromRectAndRadius(r, Radius.circular(size * 0.4));
        canvas.drawRRect(rp, paint);
      }
      return;
    }

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = size;

    if (type == StrokeType.pencil) {
      paint.strokeWidth = size.clamp(2, 6);
    }

    if (type == StrokeType.glitter) {
      paint.maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 4);
    }

    if (type == StrokeType.eraser) {
      // True eraser: removes previous strokes in this layer instead of drawing white.
      paint
        ..color = Colors.transparent
        ..blendMode = ui.BlendMode.clear;
    }

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ColoringPainter old) {
    // Always repaint canvas - simple and reliable approach
    // (small size, no performance issues).
    return true;
  }
}

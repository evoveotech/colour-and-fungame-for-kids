import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/template.dart';
import '../services/sound_service.dart';
import '../widgets/styled_category_text.dart';

class TemplateScreen extends StatefulWidget {
  final String categoryKey;
  final String categoryName;

  const TemplateScreen({
    super.key,
    required this.categoryKey,
    required this.categoryName,
  });

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  bool _soundOn = true;

  void _openTemplate(BuildContext context, TemplateItem t, String? backgroundPath) {
    Navigator.pushNamed(
      context,
      '/color',
      arguments: {
        'templateAsset': t.assetPath,
        'templateName': t.name,
        'backgroundImagePath': backgroundPath,
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _soundOn = !SoundService().isMuted;
  }

  @override
  Widget build(BuildContext context) {
    final templates = getTemplatesForCategory(widget.categoryKey);

    Category? category;
    try {
      category = categories.firstWhere((c) => c.key == widget.categoryKey);
    } catch (_) {
      category = null;
    }

    final categoryColor = category?.color ?? Theme.of(context).colorScheme.primary;
    final backgroundPath = category?.backgroundImagePath;

    String displayName(String name) {
      if (name.isEmpty) return name;
      return name[0].toUpperCase() + name.substring(1);
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (backgroundPath != null)
            Opacity(
              // Make background slightly subtle (uniform, not just bottom-only).
              opacity: 0.7,
              child: Image.asset(
                backgroundPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          Column(
            children: [
              SafeArea(
                top: true,
                bottom: false,
                minimum: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
                  child: Row(
                    children: [
                      _roundOrangeButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Center(
                          child: StyledCategoryText(
                            text: displayName(widget.categoryName),
                            categoryColor: categoryColor,
                          ),
                        ),
                      ),
                      _roundOrangeButton(
                        icon: _soundOn ? Icons.volume_up : Icons.volume_off,
                        onTap: () async {
                          await SoundService().toggleMute();
                          if (!mounted) return;
                          setState(() {
                            _soundOn = !SoundService().isMuted;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const padding = 16.0;
                    const spacing = 12.0;
                    // 4 columns, 2 rows visible at a time – extra templates can
                    // be viewed by horizontal scrolling.
                    final contentWidth = constraints.maxWidth - padding * 2;
                    final availableHeight = constraints.maxHeight - padding * 2;
                    // Calculate card size to fit 2 rows properly
                    final cardWidth = (contentWidth - spacing * 3) / 4;
                    // Use available height to ensure both rows fit: 2 rows + 1 spacing between them
                    final maxCardHeight = (availableHeight - spacing) / 2;
                    final cardHeight = (cardWidth / 0.85).clamp(0.0, maxCardHeight);

                    // Total columns needed when we arrange items in 2 rows.
                    const rows = 2;
                    final totalColumns = (templates.length / rows).ceil().clamp(1, 1000);

                    // Actual required width for all columns.
                    final columnsWidth = totalColumns * cardWidth + (totalColumns - 1) * spacing;
                    // Scrollable width - at least viewport width, more if content needs scrolling.
                    final scrollWidth = columnsWidth < contentWidth ? contentWidth : columnsWidth;

                    // Helper to build one row (rowIndex 0 = top, 1 = bottom)
                    List<Widget> buildRow(int rowIndex) {
                      final rowChildren = <Widget>[];
                      for (var col = 0; col < totalColumns; col++) {
                        if (col > 0) {
                          rowChildren.add(const SizedBox(width: spacing));
                        }
                        final idx = col * rows + rowIndex;
                        if (idx >= templates.length) {
                          rowChildren.add(SizedBox(width: cardWidth, height: cardHeight));
                        } else {
                          final t = templates[idx];
                          rowChildren.add(
                            SizedBox(
                              width: cardWidth,
                              height: cardHeight,
                              child: _TemplateCard(
                                template: t,
                                onTap: () => _openTemplate(context, t, backgroundPath),
                              ),
                            ),
                          );
                        }
                      }
                      return rowChildren;
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: padding, vertical: padding),
                      child: SizedBox(
                        width: scrollWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // First line (top row)
                            Row(
                              children: buildRow(0),
                            ),
                            SizedBox(height: spacing),
                            // Second line (bottom row)
                            Row(
                              children: buildRow(1),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundOrangeButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE0852A), // Warm orange
            border: Border.all(
              color: const Color(0xFFF5E0C0), // Light beige/gold border
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
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
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final TemplateItem template;
  final VoidCallback onTap;

  const _TemplateCard({required this.template, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            template.assetPath,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => Image.asset(
              template.assetPathPng,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => _PlaceholderTemplate(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown when template image is missing - simple line-art style placeholder.
class _PlaceholderTemplate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SimpleOutlinePainter(),
      size: Size.infinite,
    );
  }
}

class _SimpleOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    const margin = 24.0;
    final r = Rect.fromLTWH(margin, margin, size.width - 2 * margin, size.height - 2 * margin);
    canvas.drawOval(r, paint);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.35), 8, paint);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.35), 8, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

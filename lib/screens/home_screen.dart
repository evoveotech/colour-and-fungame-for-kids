import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/category.dart';
import '../widgets/animated_dialog.dart';
import '../widgets/sidebar_menu_layout.dart';
import '../services/sound_service.dart';
import '../widgets/styled_category_text.dart';

/// Home screen: Categories displayed in circular frames matching the design.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _soundOn = true;
  late PageController _pageController;
  int _currentPage = 0;
  static const int _infiniteMultiplier = 10000; // For infinite scroll effect
  // =========================
  // Background (Video OR Image)
  // =========================
  //
  // Toggle background type:
  // - Video desired: `_useVideoBackground = true`
  // - Image desired: `_useVideoBackground = false`
  //
  // (You can switch with just 1 line comment/uncomment if you want.)
  static const bool _useVideoBackground = false;
  // static const bool _useVideoBackground = false;

  /// Background video path (looping). Used only when `_useVideoBackground == true`.
  static const String _backgroundVideoAssetAlt = 'assets/images/background/home-video.mp4';
  static const String _backgroundVideoAsset = 'images/Background/home-video.mp4';

  /// Background image path. Used only when `_useVideoBackground == false`.
  static const String _backgroundImageAssetAlt = 'assets/images/background/home.jpg';
  static const String _backgroundImageAsset = 'images/Background/home.jpeg';

  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (_useVideoBackground) {
      _initVideoBackground();
    }
    // Sync sound state with SoundService
    _soundOn = !SoundService().isMuted;
    // Start at middle for infinite scroll in both directions
    final initialPage = (categories.length * _infiniteMultiplier / 2).round();
    _currentPage = initialPage;
    _pageController = PageController(
      initialPage: initialPage,
      viewportFraction: 0.33, // Show exactly 3 items (1/3 = 0.33)
    );
    _pageController.addListener(_onPageChanged);
  }

  Future<void> _initVideoBackground() async {
    if (!_useVideoBackground) return;
    for (final path in [_backgroundVideoAsset, _backgroundVideoAssetAlt]) {
      try {
        final c = VideoPlayerController.asset(path);
        await c.initialize();
        if (!mounted) {
          c.dispose();
          return;
        }
        c.setLooping(true);
        await c.play();
        setState(() => _videoController = c);
        return;
      } catch (_) {
        continue;
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _videoController = null;
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? _currentPage;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  int _getCategoryIndex(int pageIndex) {
    return pageIndex % categories.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SafeArea(left: false, right: false, top: true, bottom: false, child: _buildTopBar(context)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: _buildCategoriesGrid(context),
                    ),
                  ),
                  SafeArea(left: false, right: false, top: false, bottom: true, child: _buildBottomButtons(context)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    if (_useVideoBackground) {
      final controller = _videoController;
      if (controller != null && controller.value.isInitialized) {
        return Opacity(
          opacity: 0.8,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        );
      }
      return _gradientBackground();
    }

    // Image background
    return Opacity(
      opacity: 0.85,
      child: Image.asset(
        _backgroundImageAsset,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          _backgroundImageAssetAlt,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _gradientBackground(),
        ),
      ),
    );
  }

  Widget _gradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFC8E6C9),
            Color(0xFFB3E5FC),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0), // Minimal vertical padding to reduce gap
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu button - top left (using custom menu icon image)
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SidebarMenuLayout(),
                ),
              );
            },
            padding: EdgeInsets.zero, // Remove default IconButton padding
            constraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            icon: Image.asset(
              'images/menu-icon.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to icon if image fails to load
                return const Icon(Icons.menu, color: Colors.black, size: 24);
              },
            ),
          ),
          // Show current category name in center with styled text (first image style)
          // Animated with circular motion matching category images
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  // Get the current page value for smooth animation
                  double pageValue = 0.0;
                  if (_pageController.hasClients && _pageController.position.haveDimensions) {
                    final currentPage = _pageController.page ?? _currentPage.toDouble();
                    final centerPage = _currentPage.toDouble();
                    pageValue = currentPage - centerPage;
                  }
                  
                  // Get category based on current page (rounded)
                  final categoryIndex = _getCategoryIndex(_currentPage);
                  final category = categories[categoryIndex];
                  
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                            CurvedAnimation(parent: animation, curve: Curves.easeOut),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: _buildStyledCategoryText(
                      _capitalizeFirst(category.name),
                      category.color,
                      pageValue,
                      key: ValueKey(categoryIndex), // Key for AnimatedSwitcher
                    ),
                  );
                },
              ),
            ),
          ),
          // Sound toggle button - positioned at top right (round, matching other buttons style)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                SoundService().toggleMute().then((_) {
                  setState(() {
                    _soundOn = !SoundService().isMuted;
                  });
                });
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE0852A), // Warm orange color
                  border: Border.all(
                    color: const Color(0xFFF5E0C0), // Light beige/gold border
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Icon(
                  _soundOn ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      physics: const PageScrollPhysics(), // Smooth page scrolling
      itemCount: categories.length * _infiniteMultiplier, // Infinite scroll
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemBuilder: (context, index) {
        final categoryIndex = _getCategoryIndex(index);
        final category = categories[categoryIndex];
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double value = 1.0;
            double pageValue = 0.0;
            if (_pageController.hasClients && _pageController.position.haveDimensions) {
              final currentPage = _pageController.page ?? index.toDouble();
              pageValue = currentPage - index;
              // Smoother scaling curve
              value = (1 - (pageValue.abs() * 0.6)).clamp(0.0, 1.0);
            }
            return _buildCategoryCard(context, category, index, value, pageValue);
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category, int index, double scale, double pageValue) {
    // Smooth size transition: 280px center, 196px side (30% smaller)
    final size = 196.0 + (84.0 * scale); // 196 + (280-196) * scale
    // Smooth vertical offset: 0px center, 40px side
    final verticalOffset = 40.0 * (1 - scale);
    
    // Calculate curved path position for carousel effect
    final curveOffset = _calculateCurveOffset(pageValue);
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/templates',
          arguments: {
            'categoryKey': category.key,
            'categoryName': category.name,
          },
        );
      },
      child: Transform.translate(
        offset: Offset(0, verticalOffset + curveOffset),
        child: Transform.scale(
          scale: scale.clamp(0.7, 1.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // No name below image - only show in top bar
                const SizedBox(height: 0), // Removed spacer to reduce gap between text and image
                // Circular category image frame
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      category.categoryImagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(
                          color: category.color.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.image,
                          size: 60,
                          color: category.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }

  // Calculate curved offset for carousel animation (parabolic arc)
  double _calculateCurveOffset(double pageValue) {
    // Create a curved path: items move in an arc as they scroll
    final absValue = pageValue.abs();
    if (absValue > 1.5) return 0.0;
    
    // Smooth parabolic curve: center is at top, sides curve downward
    // Reduced curve height to prevent overflow
    final curveHeight = 25.0; // Reduced from 35.0 to prevent overflow
    final normalized = absValue.clamp(0.0, 1.0);
    // Smooth curve using easeOutCubic-like function
    return curveHeight * normalized * normalized * (3.0 - 2.0 * normalized);
  }

  Widget _buildStyledCategoryText(String text, Color categoryColor, double pageValue, {Key? key}) {
    // Calculate scale and offset similar to category images
    final scale = (1 - (pageValue.abs() * 0.6)).clamp(0.7, 1.0);
    final curveOffset = _calculateCurveOffset(pageValue);
    
    return Container(
      key: key,
      child: Transform.translate(
        offset: Offset(0, curveOffset * 0.3), // Slight vertical movement matching images
        child: Transform.scale(
          scale: scale,
          child: StyledCategoryText(text: text, categoryColor: categoryColor),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    // SafeArea already handled in parent build (we keep left/right edge-to-edge).
    return SafeArea(
      left: false,
      right: false,
      top: false,
      child: Padding(
        // Match top bar horizontal padding (12) for vertical alignment
        padding: const EdgeInsets.fromLTRB(12, 2, 12, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _bottomButton(
              icon: Icons.star,
              label: 'RATE US',
              onTap: () {
                AnimatedDialog.show(
                  context,
                  type: DialogType.rateUs,
                  onPrimaryAction: () {
                    // Handle rate action - open app store/play store
                    // Example: launch('https://play.google.com/store/apps/details?id=your.package.name');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for rating! ⭐'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  onSecondaryAction: () {
                    // Handle cancel action
                  },
                );
              },
            ),
            // REMOVE ADS button aligned to right (same vertical line as volume button)
            // _bottomButton(
            //   icon: Icons.block,
            //   label: 'REMOVE ADS',
            //   onTap: () {
            //     AnimatedDialog.show(
            //       context,
            //       type: DialogType.removeAds,
            //       customPrice: '₹85.00',
            //       onPrimaryAction: () {
            //         // Handle purchase action
            //         // Example: initiatePurchase();
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(
            //             content: Text('Processing purchase... 💳'),
            //             duration: Duration(seconds: 2),
            //           ),
            //         );
            //       },
            //       onSecondaryAction: () {
            //         // Handle cancel action
            //       },
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _bottomButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onTap();
        },
        borderRadius: BorderRadius.circular(25),
        child: Container(
          // YAHAN PADDING KAM KIYA - horizontal: 24 se 14, vertical: 14 se 10
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE0852A), // Warm orange color
            borderRadius: BorderRadius.circular(25), // Border radius bhi thoda kam
            border: Border.all(
              color: const Color(0xFFF5E0C0), // Light beige/gold border
              width: 2, // Border width 3 se 2 kar diya
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 8, // Shadow blur bhi thoda kam
                offset: const Offset(0, 3),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 18, // Icon size 24 se 18 kar diya
              ),
              const SizedBox(width: 6), // Spacing 10 se 6 kar diya
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12, // Font size 14 se 12 kar diya
                  letterSpacing: 0.3, // Letter spacing bhi thoda kam
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

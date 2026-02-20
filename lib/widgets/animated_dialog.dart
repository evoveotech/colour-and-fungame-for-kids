import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Animated dialog types
enum DialogType {
  rateUs,
  removeAds,
}

/// Beautiful animated dialog with smooth entrance/exit animations
class AnimatedDialog extends StatefulWidget {
  final DialogType type;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final String? customTitle;
  final String? customMessage;
  final String? customPrice;

  const AnimatedDialog({
    super.key,
    required this.type,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.customTitle,
    this.customMessage,
    this.customPrice,
  });

  /// Show the dialog
  static Future<void> show(
    BuildContext context, {
    required DialogType type,
    VoidCallback? onPrimaryAction,
    VoidCallback? onSecondaryAction,
    String? customTitle,
    String? customMessage,
    String? customPrice,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AnimatedDialog(
          type: type,
          onPrimaryAction: onPrimaryAction,
          onSecondaryAction: onSecondaryAction,
          customTitle: customTitle,
          customMessage: customMessage,
          customPrice: customPrice,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Combined scale + fade animation
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        
        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _starsController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _starsAnimation;
  int _selectedStars = 0;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for dialog container
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Stars animation for Rate Us dialog
    if (widget.type == DialogType.rateUs) {
      _starsController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      _starsAnimation = CurvedAnimation(
        parent: _starsController,
        curve: Curves.elasticOut,
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    if (widget.type == DialogType.rateUs) {
      _starsController.dispose();
    }
    super.dispose();
  }

  String get _title {
    if (widget.customTitle != null) return widget.customTitle!;
    return widget.type == DialogType.rateUs ? 'LIKE OUR APP?' : 'REMOVE ADS';
  }

  String get _message {
    if (widget.customMessage != null) return widget.customMessage!;
    return widget.type == DialogType.rateUs
        ? 'Would you like to take a moment and review our app?'
        : 'Enjoy Ads-free version with a one-time purchase';
  }

  String get _price {
    if (widget.customPrice != null) return widget.customPrice!;
    return widget.type == DialogType.removeAds ? '₹85.00' : '';
  }

  Color get _primaryColor {
    return widget.type == DialogType.rateUs
        ? const Color(0xFFFF6B35) // Orange for Rate Us
        : const Color(0xFF4CAF50); // Green for Remove Ads
  }

  Color get _secondaryColor {
    return widget.type == DialogType.rateUs
        ? const Color(0xFFFFB84D) // Light orange
        : const Color(0xFF81C784); // Light green
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: child,
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: _primaryColor.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Stack(
                children: [
                  // Gradient background overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _primaryColor.withOpacity(0.1),
                            _secondaryColor.withOpacity(0.05),
                            Colors.white,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Close button
                        Align(
                          alignment: Alignment.topRight,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1.5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Title
                        _buildTitle(),
                        const SizedBox(height: 16),
                        // Message
                        _buildMessage(),
                        const SizedBox(height: 24),
                        // Stars (for Rate Us) or Price (for Remove Ads)
                        if (widget.type == DialogType.rateUs)
                          _buildStars()
                        else
                          _buildPrice(),
                        const SizedBox(height: 32),
                        // Action buttons
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      _title,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: _primaryColor,
        letterSpacing: 1.2,
        shadows: [
          Shadow(
            color: _primaryColor.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildMessage() {
    return Text(
      _message,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.grey[800],
        height: 1.4,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildPrice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Text(
        _price,
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
      ),
    );
  }

  Widget _buildStars() {
    return AnimatedBuilder(
      animation: _starsAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_starsAnimation.value * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final isSelected = index < _selectedStars;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStars = index + 1;
                  });
                  _starsController.forward(from: 0.0);
                },
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween<double>(
                    begin: 0.0,
                    end: isSelected ? 1.0 : 0.0,
                  ),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 1.0 + (value * 0.2),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          Icons.star,
                          size: 48,
                          color: isSelected
                              ? const Color(0xFFFFD700)
                              : Colors.grey[300],
                          shadows: isSelected
                              ? [
                                  Shadow(
                                    color: const Color(0xFFFFD700).withOpacity(0.5),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Primary button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              widget.onPrimaryAction?.call();
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                widget.type == DialogType.rateUs ? 'RATE NOW' : 'REMOVE ADS',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.0,
                  shadows: [
                    const Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Secondary button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              widget.onSecondaryAction?.call();
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No, thanks',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

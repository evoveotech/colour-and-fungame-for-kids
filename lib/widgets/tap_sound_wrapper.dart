import 'package:flutter/material.dart';
import '../services/sound_service.dart';

/// Wrapper widget that adds tap sound to any widget
class TapSoundWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;

  const TapSoundWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled || onTap == null) {
      return child;
    }

    return GestureDetector(
      onTap: () {
        SoundService().playTapSound();
        onTap?.call();
      },
      child: child,
    );
  }
}

/// Extension to easily add tap sound to InkWell/InkResponse
extension TapSoundExtension on Widget {
  /// Wrap widget with tap sound
  Widget withTapSound({VoidCallback? onTap, bool enabled = true}) {
    return TapSoundWrapper(
      onTap: onTap,
      enabled: enabled,
      child: this,
    );
  }
}

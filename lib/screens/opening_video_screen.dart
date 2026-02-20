import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../services/sound_service.dart';
import 'home_screen.dart';

/// First screen shown when app opens – plays an intro video once,
/// then navigates to the main HomeScreen.
class OpeningVideoScreen extends StatefulWidget {
  const OpeningVideoScreen({super.key});

  @override
  State<OpeningVideoScreen> createState() => _OpeningVideoScreenState();
}

class _OpeningVideoScreenState extends State<OpeningVideoScreen> {
  VideoPlayerController? _controller;
  bool _navigated = false;
  Timer? _checkTimer;

  @override
  void initState() {
    super.initState();
    // Initialize video immediately - minimize black screen delay
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      final c = VideoPlayerController.asset('assets/opening-video.mp4');
      
      // Do not loop video - play it only once
      c.setLooping(false);
      
      // Initialize video - update UI immediately to minimize black screen
      c.initialize().then((_) {
        if (!mounted) {
          c.dispose();
          return;
        }
        
        // Update UI immediately so video appears (minimize black screen)
        setState(() {
          _controller = c;
        });
        
        // Start playing video
        c.play().then((_) {
          // Start timer that checks every 100ms if video has ended
          if (mounted) {
            _checkTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
              _checkVideoCompletion();
            });
          }
        });
      }).catchError((_) {
        // If video initialization fails, go to home screen directly
        if (mounted) {
          _goToHome();
        }
      });
    } catch (_) {
      // If video not found / failed to load, go to home screen directly.
      if (mounted) {
        _goToHome();
      }
    }
  }

  void _checkVideoCompletion() {
    if (_navigated || !mounted) {
      _checkTimer?.cancel();
      return;
    }
    
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    
    final position = c.value.position;
    final duration = c.value.duration;
    
    // Video has ended if:
    // 1. Duration is valid (> 0)
    // 2. Position is equal to or greater than duration (strict check - video must fully finish)
    if (duration.inMilliseconds > 0) {
      final positionMs = position.inMilliseconds;
      final durationMs = duration.inMilliseconds;
      
      // Video end check: position >= duration (with 30ms tolerance for timing precision)
      // This ensures video has completely finished
      if (positionMs >= durationMs - 30) {
        _checkTimer?.cancel();
        // Small delay to ensure video fully finishes before navigation
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted && !_navigated) {
            _goToHome();
          }
        });
      }
    }
  }

  void _goToHome() {
    if (_navigated || !mounted) return;
    _navigated = true;

    // Ensure background music starts when navigating to home screen.
    SoundService().ensureBackgroundPlaying();

    // Instant navigation - no transition delay
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionDuration: Duration.zero, // Instant transition - no delay
        transitionsBuilder: (_, animation, __, child) {
          return child; // No animation - instant switch
        },
      ),
    );
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      backgroundColor: Colors.black,
      body: controller != null && controller.value.isInitialized
          ? SizedBox.expand(
              // Har screen size par edge‑to‑edge cover
              child: FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            )
          : Container(
              // Black screen until video loads (matches native splash)
              color: Colors.black,
            ),
    );
  }
}


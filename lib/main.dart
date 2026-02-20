import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/opening_video_screen.dart';
import 'screens/template_screen.dart';
import 'screens/coloring_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/about_us_screen.dart';
import 'services/sound_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Game always in landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // Hide status bar + navigation bar for true full‑screen (like other games)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Draw edge-to-edge so content isn't letterboxed
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  
  // Start app immediately - sound initialization happens in the background
  runApp(const TinyMindsApp());
  
  // Initialize sound service in background (non-blocking)
  // OpeningVideoScreen will show immediately, sound will be ready later
  SoundService().initialize().catchError((e) {
    // Silent fail - app will continue even if sound doesn't play
  });
}

class TinyMindsApp extends StatefulWidget {
  const TinyMindsApp({super.key});

  @override
  State<TinyMindsApp> createState() => _TinyMindsAppState();
}

class _TinyMindsAppState extends State<TinyMindsApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final soundService = SoundService();

    switch (state) {
      case AppLifecycleState.resumed:
        // Resume background music immediately when app comes to foreground.
        soundService.ensureBackgroundPlaying();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        // When app is in background / multi-tasking view / hidden state,
        // pause music so user doesn't hear unnecessary background sound.
        soundService.pauseBackground();
        break;
      case AppLifecycleState.detached:
        // App is shutting down completely -> free audio resources.
        soundService.dispose();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color & Fun',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Remove ONLY left/right system cutout padding so landscape camera side
        // doesn't reserve extra blank space. (True edge-to-edge like games.)
        final mq = MediaQuery.of(context);
        final edgeToEdgeMq = mq.copyWith(
          padding: mq.padding.copyWith(left: 0, right: 0),
          viewPadding: mq.viewPadding.copyWith(left: 0, right: 0),
        );

        // Global tap sound: plays even when user taps on empty space.
        return MediaQuery(
          data: edgeToEdgeMq,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => SoundService().playTapSound(),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFFFF6584),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const OpeningVideoScreen(),
      routes: {
        '/home': (_) => const HomeScreen(),
        '/about': (_) => const AboutUsScreen(),
        '/faq': (_) => const FAQScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/templates': (c) {
          final args = ModalRoute.of(c)!.settings.arguments as Map<String, dynamic>?;
          return TemplateScreen(
            categoryKey: args?['categoryKey'] ?? 'animals',
            categoryName: args?['categoryName'] ?? 'Animals',
          );
        },
        '/color': (c) {
          final args = ModalRoute.of(c)!.settings.arguments as Map<String, dynamic>?;
          return ColoringScreen(
            templateAsset: args?['templateAsset'] as String? ?? '',
            templateName: args?['templateName'] as String? ?? 'Picture',
            backgroundImagePath: args?['backgroundImagePath'] as String?,
          );
        },
      },
    );
  }
}

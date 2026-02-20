import 'package:audioplayers/audioplayers.dart';

/// Service to manage background audio and tap sounds throughout the app
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _tapPlayer = AudioPlayer();
  
  bool _isMuted = false;
  bool _isInitialized = false;
  int _lastTapSoundMs = 0;

  /// Background audio asset path
  static const String backgroundAudioPath = 'assets/sounds/background-audio.mp3';
  
  /// Tap sound asset path
  static const String tapSoundPath = 'assets/sounds/tap-sound.mp3';

  /// Initialize and start background audio
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Audio focus/config:
      // - Background music uses normal focus (gain) and can keep playing when screen locks.
      // - Tap SFX uses "mixWithOthers" so it does NOT steal focus and pause background music.
      await _backgroundPlayer.setAudioContext(
        AudioContextConfig(
          focus: AudioContextConfigFocus.gain,
          stayAwake: true,
        ).build(),
      );
      await _tapPlayer.setAudioContext(
        AudioContextConfig(
          focus: AudioContextConfigFocus.mixWithOthers,
        ).build(),
      );

      // Use low latency mode for short tap SFX (prevents interrupting background on Android).
      await _tapPlayer.setPlayerMode(PlayerMode.lowLatency);

      await _startBackground();
      
      _isInitialized = true;
    } catch (e) {
      print('Error initializing background audio: $e');
    }
  }

  Future<void> _startBackground() async {
    // Set release mode to loop for background audio
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);

    // Load + play background audio
    await _backgroundPlayer.play(
      AssetSource('sounds/background-audio.mp3'),
      volume: 0.5, // 50% default
    );
  }

  /// Ensure background audio is playing (useful after app resume / focus changes).
  Future<void> ensureBackgroundPlaying() async {
    if (_isMuted) return;

    try {
      if (!_isInitialized) {
        await initialize();
        return;
      }

      // Resume if possible; if it fails, restart from asset.
      await _backgroundPlayer.resume();
    } catch (_) {
      try {
        await _startBackground();
      } catch (e) {
        print('Error restarting background audio: $e');
      }
    }
  }

  /// Pause background music when app goes to background.
  Future<void> pauseBackground() async {
    try {
      await _backgroundPlayer.pause();
    } catch (e) {
      print('Error pausing background audio: $e');
    }
  }

  /// Play tap sound (only when not muted)
  Future<void> playTapSound() async {
    try {
      if (_isMuted) return;

      // Debounce so a single interaction doesn't double-trigger.
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastTapSoundMs < 80) return;
      _lastTapSoundMs = now;

      // Play tap sound (keep it short + reliable start)
      try {
        await _tapPlayer.stop();
      } catch (_) {}
      await _tapPlayer.play(
        AssetSource('sounds/tap-sound.mp3'),
        volume: 1.0,
      );

      // If any platform pauses background due to focus quirks, immediately resume it.
      Future<void>.delayed(const Duration(milliseconds: 30), ensureBackgroundPlaying);
    } catch (e) {
      // Silently fail if tap sound can't be played
      print('Error playing tap sound: $e');
    }
  }

  /// Toggle mute/unmute background audio
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    
    if (_isMuted) {
      await _backgroundPlayer.pause();
    } else {
      await ensureBackgroundPlaying();
    }
  }

  /// Check if audio is muted
  bool get isMuted => _isMuted;

  /// Dispose all audio players
  Future<void> dispose() async {
    await _backgroundPlayer.dispose();
    await _tapPlayer.dispose();
  }
}

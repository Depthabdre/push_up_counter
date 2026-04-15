import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

/// The blueprint (interface) for our Smart Coach audio
abstract class AppAudioPlayer {
  Future<void> init();
  Future<void> speakNumber(int number);
  Future<void> playHypeSound(String fileName);
}

/// The actual implementation
class AppAudioPlayerImpl implements AppAudioPlayer {
  final FlutterTts _flutterTts;
  final AudioPlayer _audioPlayer;

  AppAudioPlayerImpl(this._flutterTts, this._audioPlayer);

  @override
  Future<void> init() async {
    // 1. Setup the Robot Voice (TTS)
    await _flutterTts.setLanguage("en-US");

    // Make it sound deeper and faster for that "Gym Coach" vibe
    await _flutterTts.setSpeechRate(0.55); // Faster (Default is usually 0.5)
    await _flutterTts.setPitch(0.8); // Deeper (Default is 1.0)

    // 2. Setup AudioPlayer settings (optional, but good practice)
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  @override
  Future<void> speakNumber(int number) async {
    // Yells out the number. e.g., "Fifteen!"
    await _flutterTts.speak(number.toString());
  }

  @override
  Future<void> playHypeSound(String fileName) async {
    // Plays audio files from your assets/audio folder
    // Supports both .mp3 and .wav formats
    // Note: The AssetSource automatically looks inside the 'assets/' folder.
    // So if you pass "audio/coach_push.wav", it will find it.
    await _audioPlayer.play(AssetSource(fileName));
  }
}
